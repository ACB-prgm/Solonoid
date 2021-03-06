extends Node2D



onready var tween = $Tween
onready var light = $Light2D


func _ready():
	
	tween.interpolate_property(light, "energy", null, 0.0, 
	0.2, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	tween.start()
	
	$AnimatedSprite.set_frame(0)
	$AnimatedSprite.play()


func _on_Particles2D_Plus_particles_cycle_finished():
	queue_free()
