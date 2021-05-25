extends Area2D


const SPEED = 5000
const SPAWN_COLOR = Color(4,5,5,0)

onready var trail = $BulletTrailLine2D
onready var tween = $Tween
onready var light = $Light2D
onready var drift := rand_range(-.025, .025)

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

func _on_Area2D_body_entered(_body):
	die()

func _on_VisibilityNotifier2D_screen_exited():
	die()


func die():
	if !dead:
		dead = true
		
		set_deferred("monitorable", false) # stops causing damage
		set_physics_process(false) # stops movement
		
		$Bullet.hide()
		$Particles2D.set_emitting(false)
		
		tween.interpolate_property(light, "energy", light.energy, 0.0, 
		0.15, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
		tween.start()
		
		trail.end()


func _on_BulletTrailTween_tween_completed(object, key):
	queue_free()
