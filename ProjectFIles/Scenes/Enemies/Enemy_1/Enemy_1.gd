extends KinematicBody2D


export var speed = 800
export var steer_force = 200.0

onready var thrusterSound = $ThusterSound
onready var tween = $Tween
onready var damaged_light = $DamagedLight2D

var death_TSCN = preload("res://Scenes/Enemies/EnemyDeaths/Enemy_Death.tscn")
var velocity := Vector2.RIGHT
var desired := Vector2.LEFT
var acceleration := Vector2.ZERO
var repel
var health := 3
var repel_force: float
var repel_distance: float
var dead := false
var target

var state = SEEK
enum {
	SEEK,
	REPEL
}


func _ready():
	randomize()
	target = Globals.player


func _physics_process(delta):
	thruster_sounds()
	match state:
		SEEK:
			seek(delta)
		REPEL:
			_repel()


# MOVEMENT FUNCTIONS ———————————————————————————————————————————————————————————
func seek(delta):
	var steer = Vector2.ZERO
	if target and is_instance_valid(target):
		desired = global_position.direction_to(target.global_position) * speed
		steer = (desired - velocity).normalized() * steer_force
	
	acceleration += steer
	velocity += acceleration * delta
	velocity = velocity.clamped(speed)
	rotation = velocity.angle()
# warning-ignore:return_value_discarded
	move_and_slide(velocity)


func _repel():
	if repel and is_instance_valid(repel):
		velocity += repel.global_position.direction_to(global_position) * repel_force
		velocity = velocity.clamped(speed)
		rotation = velocity.angle()
# warning-ignore:return_value_discarded
		move_and_slide(velocity)
		
		if global_position.distance_to(repel.global_position) > repel_distance:
			state = SEEK
	else:
		state = SEEK


func _on_RepelArea_area_entered(area):
	repel = area 
	repel_force = rand_range(10, 40)
	repel_distance = rand_range(150, 300)
	
	state = REPEL


func thruster_sounds():
	if !dead:
		if target and is_instance_valid(target):
			var nearness = 200/global_position.distance_to(target.global_position)
			nearness = clamp(nearness, 0.0, 1.0)
			thrusterSound.volume_db = lerp(-10.0, 8.0, nearness)
		
		if desired and velocity:
			var thrust = (desired - velocity).length() / 1200
			thrust = clamp(thrust, 0.0, 1.0)
			thrusterSound.pitch_scale = lerp(6.0, 3.0, thrust)


# DAMAGE AND DEATH FUNCTIONS ———————————————————————————————————————————————————
func take_damage(damage, direction):
	#called by bullet
	health -= damage
	
	if health <= 0:
		die()
	
	velocity = Vector2.ZERO
	flash_light(direction)


func flash_light(direction):
	var flash_pos = direction * 50
	
	damaged_light.position = flash_pos
	damaged_light.offset = Vector2(flash_pos.y * -1.0, flash_pos.x)
	
	tween.interpolate_property(damaged_light, "energy", 2.0, 0.0, 
	0.3, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	tween.start()


func die():
	if !dead:
		dead = true
		
		tween.interpolate_property(thrusterSound, "pitch_scale", 
		null, 20.0 + rand_range(-2, 2), 
		.3, Tween.TRANS_EXPO, Tween.EASE_IN)
		tween.interpolate_property(thrusterSound, "volume_db", 
		null, clamp(thrusterSound.volume_db + 5, 0.0, 10.0), 
		.35, Tween.TRANS_EXPO, Tween.EASE_IN)
		tween.start()


func _on_Tween_tween_completed(_object, key):
	if key == ":pitch_scale":
		var death_ins = death_TSCN.instance()
		death_ins.global_position = global_position
		get_parent().add_child(death_ins)
		
		queue_free()
