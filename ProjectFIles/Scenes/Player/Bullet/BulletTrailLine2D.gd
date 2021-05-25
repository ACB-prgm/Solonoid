extends Line2D


onready var tween = $Tween
onready var start_pos = global_position


func _physics_process(_delta):
	points[1] = to_local(start_pos)


func end():
	set_physics_process(false)
	tween.interpolate_property(self, "modulate", modulate, Color(1,1,1,0), 
	0.2, Tween.TRANS_QUAD, Tween.EASE_OUT, .1)
	tween.interpolate_property(self, "width", width, 0, 
	0.25, Tween.TRANS_QUAD, Tween.EASE_OUT, .1)
	tween.start()
