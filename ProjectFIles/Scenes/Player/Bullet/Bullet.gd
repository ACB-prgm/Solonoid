extends Area2D


const SPEED = 5000
const SPAWN_COLOR = Color(4,5,5,0)

onready var trail = $BulletTrailLine2D
onready var tween = $Tween
onready var light = $Light2D
onready var drift := rand_range(-.025, .025)

var impact_TSCN = preload("res://Scenes/Player/Bullet/BulletImpact.tscn")
var dead := false
var damage := 1


func _ready():
	tween.interpolate_property(self, "modulate", SPAWN_COLOR, modulate, 
	0.1, Tween.TRANS_CIRC, Tween.EASE_IN)
	tween.start()


func _physics_process(delta):
	global_position += Vector2.RIGHT.rotated(rotation + drift) * SPEED * delta


func _on_Area2D_area_entered(_area):
	die()

func _on_Area2D_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage, body.global_position.direction_to(global_position))
	die()

func _on_VisibilityNotifier2D_screen_exited():
	die(true)


func die(offscreen = false):
	if !dead:
		dead = true
		
		set_deferred("monitorable", false) # stops causing damage
		damage = 0
		set_physics_process(false) # stops movement
		
		$Bullet.hide()
		$Particles2D.set_emitting(false)
		$Light2D.hide()
		
		trail.end()
		
		if !offscreen:
			var impact_ins = impact_TSCN.instance()
			impact_ins.global_position = global_position
			impact_ins.rotation = rotation
			get_parent().call_deferred("add_child", impact_ins)


func _on_LineTrail_Tween_tween_all_completed():
	queue_free()
