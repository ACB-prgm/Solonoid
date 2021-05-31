tool
extends Label


const BLUE = Color(0.65, 1.0, 0.99, 1.0)

#onready var hoverSound = $HoverSound
#onready var clickSound = $ClickSound
onready var animPlayer = $AnimationPlayer

signal TextButton_Pressed


func _ready():
	set_process(true)


func _process(_delta):
	if Engine.editor_hint:
		rect_pivot_offset = rect_size/2.0

	if not Engine.editor_hint:
		set_process(false)


func _on_Button_pressed():
#	clickSound.play()
	if not Engine.editor_hint:
		emit_signal("TextButton_Pressed")


func _on_Button_mouse_entered():
#	hoverSound.play()
	if not Engine.editor_hint:
		animPlayer.play("hover")


func _on_Button_mouse_exited():
	if not Engine.editor_hint:
		animPlayer.play("unhover")
