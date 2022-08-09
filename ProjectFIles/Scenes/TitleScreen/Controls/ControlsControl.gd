extends Control


const RADIUS = 100

onready var layoutPresetButton = $LayoutPresetButton
onready var WASD_Label = $WASD_Label
onready var ARROWS_Label = $ARROWS_LABEL

var dir: Vector2
var center := Vector2(3840,2160)/2.0
var scalar: float
var labels
var dirs = ["_right", "_left", "_up", "_down"]

func _ready():
	# warning-ignore:return_value_discarded
	GamePad.connect("gamepad_connected", self, "_on_GamePad_controller_connected")
# warning-ignore:return_value_discarded
	GamePad.connect("gamepad_disconnected", self, "_on_GamePad_controller_disconnected")
	
	set_input_map(Globals.layout_preset)
	layoutPresetButton.text = Globals.layout_preset
	
	labels = get_children()
	for label in get_children():
		if !label.get("custom_constants/shadow_offset_x"):
			labels.erase(label)
	
	Transitioner._in()


func _process(_delta):
	var mouse_pos = get_global_mouse_position()
	dir = mouse_pos.direction_to(center)
	scalar = mouse_pos.distance_to(center)
	scalar = clamp(scalar, 0, RADIUS)
	var t = scalar/RADIUS * 14.0
	
	for label in labels:
		
		label.set("custom_constants/shadow_offset_x", dir.x * t)
		label.set("custom_constants/shadow_offset_y", dir.y * t)


func _on_BackButton_TextButton_Pressed():
	Globals.save_data()
	Transitioner.change_title_page("TITLE")


func _on_LayoutPresetButton_TextButton_Pressed():
	
	match Globals.layout_preset:
		"DEFAULT":
			set_input_map('LEFTY')
		"LEFTY":
			set_input_map('DEFAULT')

	layoutPresetButton.text = Globals.layout_preset


func set_input_map(preset: String):
	match preset:
		"DEFAULT":
			Globals.layout_preset = "DEFAULT"
			WASD_Label.text = "movment"
			ARROWS_Label.text = "aiming"
			
			for direc in dirs:
				var new_input = InputEventKey.new()
				var action = "ui%s" % direc
				var scancode = KEY_W
				match direc:
					"_right":
						scancode = KEY_D
					"_left":
						scancode = KEY_A
					"_up":
						scancode = KEY_W
					"_down":
						scancode = KEY_S
				
				new_input.set_scancode(scancode)
				InputMap.action_erase_events(action)
				InputMap.action_add_event(action,new_input)
			
			for direc in dirs:
				var new_input = InputEventKey.new()
				var action = "aim%s" % direc
				var scancode = KEY_W
				
				match direc:
					"_right":
						scancode = KEY_RIGHT
					"_left":
						scancode = KEY_LEFT
					"_up":
						scancode = KEY_UP
					"_down":
						scancode = KEY_DOWN
				
				new_input.set_scancode(scancode)
				InputMap.action_erase_events(action)
				InputMap.action_add_event(action,new_input)
		"LEFTY":
			Globals.layout_preset = "LEFTY"
			WASD_Label.text = "aiming"
			ARROWS_Label.text = "movement"
			
			for direc in dirs:
				var new_input = InputEventKey.new()
				var action = "ui%s" % direc
				var scancode = KEY_W
				
				match direc:
					"_right":
						scancode = KEY_RIGHT
					"_left":
						scancode = KEY_LEFT
					"_up":
						scancode = KEY_UP
					"_down":
						scancode = KEY_DOWN
				
				new_input.set_scancode(scancode)
				InputMap.action_erase_events(action)
				InputMap.action_add_event(action,new_input)
			
			for direc in dirs:
				var new_input = InputEventKey.new()
				var action = "aim%s" % direc
				var scancode = KEY_W
				
				match direc:
					"_right":
						scancode = KEY_D
					"_left":
						scancode = KEY_A
					"_up":
						scancode = KEY_W
					"_down":
						scancode = KEY_S
				
				new_input.set_scancode(scancode)
				InputMap.action_erase_events(action)
				InputMap.action_add_event(action,new_input)


# GODOT GAMEPAD FUNCTIONS ——————————————————————————————————————————————————————
func _on_ConnectGamepadButton_TextButton_Pressed():
	GamePad.search_for_controllers()


func _on_GamePad_controller_connected(id):
	Globals.GamePad_connected = id
	GamePad.stop_search_for_controllers()


func _on_GamePad_controller_disconnected(_id):
	Globals.GamePad_connected = null
