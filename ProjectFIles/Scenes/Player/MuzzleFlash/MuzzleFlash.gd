extends AnimatedSprite


const flash_duration := 0.2

onready var tween = $Tween
onready var light = $Light2D

func flash():
	frame = 0
	play()
	
	tween.interpolate_property(light, "energy", 1.0, 0.0, 
	flash_duration, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	tween.interpolate_property(light, "texture_scale", 0.3, 0.1, 
	flash_duration, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	tween.start()
