extends Line2D


onready var parent = get_parent()
onready var tween = $Tween

var last_parent_pos: Vector2
var MAX_POINTS := 10
var frame := 0


func _ready():
	yield(get_tree().create_timer(0.01), "timeout")
	if Globals._2DWorld:
		parent.call_deferred("remove_child", self)
		Globals._2DWorld.call_deferred("add_child", self)


func _physics_process(_delta):
	if !parent or !is_instance_valid(parent):
		# just free the line, the position will be handled by its parent
		set_physics_process(false)
		tween.interpolate_property(self, "modulate:a", null, 0.0, 
		0.3, Tween.TRANS_CIRC, Tween.EASE_OUT)
		tween.start()
	else:
		frame += 1
		
		if frame % 3 == 0:
			frame = 0
			draw_trail()


func draw_trail():
	add_point(to_local(parent.global_position), 0)
	
	if get_point_count() > MAX_POINTS:
		remove_point(MAX_POINTS)


func _on_Tween_tween_all_completed():
	queue_free()
