extends Button


onready var texs = [$TextureRect, $TextureRect2]

var _pressed = true


func _ready():
	pressed = Globals.shoot_on_aim
	_on_Button_toggled(Globals.shoot_on_aim)


func _on_Button_toggled(button_pressed):
	_pressed = button_pressed
	Globals.shoot_on_aim = button_pressed
	
	for tex in texs:
		tex.visible = button_pressed
	
	
