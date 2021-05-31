extends CanvasLayer


onready var animPlayer = $AnimationPlayer
onready var tween = $Tween

var _2DWorld
var hide_title = false

signal _in_finished
signal _out_finished


func _ready():
	yield(get_tree().create_timer(0.01), "timeout")
	_2DWorld = Globals._2DWorld


func _in(new_scene=null):
	if new_scene:
		for _child in _2DWorld.get_children():
			_child.queue_free()
		new_scene = load(new_scene).instance()
		_2DWorld.add_child(new_scene)
	
	tween.interpolate_method(self, "change_SE_volume", -40.0, Globals.SEs_max_db,
	0.5, Tween.TRANS_SINE, Tween.EASE_IN)
	tween.start()
	
	animPlayer.play("in")
	yield(animPlayer, "animation_finished")
	emit_signal("_in_finished")
	
	if hide_title:
		Globals.TitleScreen.hide()
	else:
		Globals.TitleScreen.show()


func _out(new_scene=null, back_in=false):
	animPlayer.play("out")
	
	tween.interpolate_method(self, "change_SE_volume", Globals.SEs_max_db, -40.0,
	0.5, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()
	
	yield(animPlayer, "animation_finished")
	emit_signal("_out_finished")
	
	if new_scene:
		for _child in _2DWorld.get_children():
			_child.queue_free()
		new_scene = load(new_scene).instance()
		_2DWorld.add_child(new_scene)
	
	if hide_title:
		Globals.TitleScreen.hide()
	else:
		Globals.TitleScreen.show()
	
	if back_in:
		yield(get_tree().create_timer(0.1), "timeout")
		_in()


func change_SE_volume(new_volume):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SoundEffects"), new_volume)
