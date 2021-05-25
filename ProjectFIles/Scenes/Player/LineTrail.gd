extends Line2D


onready var parent = get_parent()

var MAX_POINTS := 10
var frame := 0


func _ready():
	parent.call_deferred("remove_child", self)
	parent.get_parent().get_parent().get_parent().call_deferred("add_child", self)


func _physics_process(_delta):
	frame += 1
	
	if frame % 3 == 0:
		frame = 0
		draw_trail()


func draw_trail():
	add_point(to_local(parent.global_position), 0)
	
	if get_point_count() > MAX_POINTS:
		remove_point(MAX_POINTS)
