extends Control


onready var sprite = $Sprite
onready var tween = $Tween


func _ready():
	set_process(false)


func die():
	set_process(true)
	
	tween.interpolate_property(self, "rect_min_size",
	rect_min_size * 1.2, Vector2(.001, .001), 
	.19, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	tween.start()


func _process(delta):
	sprite.scale = rect_min_size


func _on_Tween_tween_all_completed():
	queue_free()
