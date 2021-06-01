extends Control


const RADIUS = 100

var dir: Vector2
var center := Vector2(3840,2160)/2.0
var scalar: float
var labels


func _ready():
	set_process(false)
	yield(get_tree().create_timer(0.1), "timeout")
	
	Transitioner._in()
	if Music.current_song != "TITLE":
		Music._in("TITLE")
	
	labels = get_children()

	for label in get_children():
		if !label.get("custom_constants/shadow_offset_x"):
			labels.erase(label)
	
	set_process(true)


func _process(_delta):
	var mouse_pos = get_global_mouse_position()
	dir = mouse_pos.direction_to(center)
	scalar = mouse_pos.distance_to(center)
	scalar = clamp(scalar, 0, RADIUS)
	
	for label in labels:
		center = label.rect_position + label.rect_size/2.0
		dir = mouse_pos.direction_to(center)
		scalar = mouse_pos.distance_to(center)
		scalar = clamp(scalar, 0.0, RADIUS)
		var t = scalar/RADIUS * 14.0
		label.set("custom_constants/shadow_offset_x", dir.x * t)
		label.set("custom_constants/shadow_offset_y", dir.y * t)


func _on_PlayButton_TextButton_Pressed():
	Transitioner._out("res://Scenes/Levels/Level1/Level_1.tscn", true)
	Music._out()
	
	set_process(false)


func _on_ControlsButton_TextButton_Pressed():
	Transitioner.change_title_page("CONTROLS")
