extends KinematicBody2D


const MAX_SPEED := 750
const ACCELERATION := 30
const KNOCKBACK_FORCE = 100

onready var shootTimer = $ShootTimer
onready var barrelPos = $BarrelPosition2D
onready var muzzleFlash = $BarrelPosition2D/MuzzleFlash
onready var thrusterAudio = $ThrustersAudio
onready var shootSound = $ShootSound
onready var tween = $Tween
onready var lineTrails = $LineTrails.get_children()

var bullet_TSCN = preload("res://Scenes/Player/Bullet/Bullet.tscn")
var can_shoot := true
var input_vector: Vector2
var velocity: Vector2
var aim_input_dir: Vector2
var aim_dir = Vector2.UP


func _ready():
	$LineTrails.hide()
	set_physics_process(false)
	var shader = $Sprite.get_material()
	shader.set("shader_param/progress", 1)
	yield(Transitioner, "_in_finished")
	
	tween.interpolate_property(shader, "shader_param/progress", 1.0, 0.0, 
	1, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
	
	Globals.player = self


func _physics_process(_delta):
#	print(Performance.get_monitor(Performance.TIME_FPS))
	movement()
	aim()
	shoot()


# MOVEMENT FUNCTIONS ———————————————————————————————————————————————————————————
func movement():
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector:
		velocity += input_vector * ACCELERATION
		velocity = velocity.clamped(MAX_SPEED)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION/2.0)
	
	var thrusT = velocity.length()/MAX_SPEED
	thrusterAudio.pitch_scale = lerp(1.5, 2.5, thrusT)
	for trail in lineTrails:
		trail.set_thrust(thrusT)

# warning-ignore:return_value_discarded
	move_and_slide(velocity)


# SHOOT FUNCTIONS ——————————————————————————————————————————————————————————————
func shoot():
	if can_shoot and (Input.is_action_pressed("shoot") or (Globals.shoot_on_aim and aim_input_dir)):
		
		can_shoot = false
		shootTimer.start()
		
		Globals.camera.shake(100, 0.18, 100, 6.5)
		velocity += Vector2.RIGHT.rotated(rotation + deg2rad(90)) * KNOCKBACK_FORCE
		muzzleFlash.flash()
		
		shootSound.pitch_scale = .55 + rand_range(-0.05, 0.1)
		shootSound.play()
		
		var bullet_ins = bullet_TSCN.instance()
		bullet_ins.rotation = rotation - deg2rad(90)
		bullet_ins.global_position = barrelPos.global_position
		get_parent().call_deferred("add_child", bullet_ins)


func _on_ShootTimer_timeout():
	can_shoot = true


# AIMING FUNCTIONS —————————————————————————————————————————————————————————————
func aim():
	aim_input_dir.x = Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left")
	aim_input_dir.y = Input.get_action_strength("aim_down") - Input.get_action_strength("aim_up")
	aim_input_dir = aim_input_dir.normalized()
	
	if aim_input_dir:
		aim_dir = aim_input_dir
	
#	aim_dir = global_position.direction_to(get_global_mouse_position())
	var aim_rot = aim_dir.angle() + deg2rad(90) # adjust for sprite rot

	rotation = _lerp_angle(rotation, aim_rot, 0.075) 

func _lerp_angle(from, to, weight):
	return from + short_angle_dist(from, to) * weight

func short_angle_dist(from, to):
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference


func _on_Tween_tween_all_completed():
	set_physics_process(true)
	Globals.camera.shake(500, 0.3, 500, 8)
	$LineTrails.show()
