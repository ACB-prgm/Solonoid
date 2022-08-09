extends Node2D



onready var tween = $Tween
onready var light = $Light2D


func _ready():
	if is_off_screen():
		queue_free()
	
	tween.interpolate_property(light, "energy", null, 0.0, 
	0.2, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	tween.start()
	
	$AnimatedSprite.set_frame(0)
	$AnimatedSprite.play()


func _on_Particles2D_Plus_particles_cycle_finished():
	queue_free()


func is_off_screen() -> bool:
	var dist_pos : Vector2 = Globals.player.global_position - global_position
	
	if abs(dist_pos.x) > 1600 or abs(dist_pos.y) > 950:
		return true
	
	return false
