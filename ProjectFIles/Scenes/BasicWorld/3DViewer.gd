extends Spatial


func _process(_delta):
	Globals.current_mouse_pos = get_viewport().get_mouse_position()
