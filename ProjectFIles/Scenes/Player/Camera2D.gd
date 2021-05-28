extends Camera2D


onready var shakeTimer = $Timer
onready var tween = $Tween
onready var ChromAbber_Shader = $CanvasLayer/ColorRect.get_material()

var shake_amount := 0.0
var current_shake_limit := 0.0
var default_offset := offset


func _ready():
	Globals.camera = self
	set_process(false)


func _process(delta):
	offset = Vector2(rand_range(-shake_amount, shake_amount), rand_range(-shake_amount, shake_amount)) * delta + default_offset


func shake(new_shake, shake_time=0.4, shake_limit=100, abberation=0.0):
	tween.stop_all()
	set_process(true)
	
	if shake_limit > current_shake_limit:
		current_shake_limit = shake_limit
	shake_amount += new_shake
	shake_amount = clamp(shake_amount, 0.0, current_shake_limit)
	
	shakeTimer.wait_time = shake_time
	shakeTimer.start()
	
	if abberation:
		tween.interpolate_property(ChromAbber_Shader, "shader_param/scale", 
		abberation, 0.0, shake_time, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
		tween.start()


func _on_Timer_timeout():
	shake_amount = 0
	set_process(false)
	
	tween.interpolate_property(self, "offset", offset, default_offset,
	0.1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()
