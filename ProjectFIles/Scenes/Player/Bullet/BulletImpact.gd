extends Node2D



onready var tween = $Tween
onready var light = $Light2D


func _ready():
	tween.interpolate_property(light, "energy", 1.0, 0.0, 
	0.2, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	tween.start()
	
	$AnimatedSprite.set_frame(0)
	$AnimatedSprite.play()


