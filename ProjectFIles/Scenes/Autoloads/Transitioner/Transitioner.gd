extends CanvasLayer


onready var animPlayer = $AnimationPlayer
onready var tween = $Tween

var _2DWorld

signal _in_finished
signal _out_finished


func _ready():
	yield(get_tree().create_timer(0.01), "timeout")
	_2DWorld = Globals._2DWorld


func _in(new_scene=null, with_SEs=true):
	if new_scene:
		for _child in _2DWorld.get_children():
			_child.queue_free()
		new_scene = load(new_scene).instance()
		_2DWorld.add_child(new_scene)
	
	if with_SEs:
		tween_SE_volume()
	
	animPlayer.play("in")
	yield(animPlayer, "animation_finished")
	emit_signal("_in_finished")


func _out(new_scene=null, back_in=false):
	animPlayer.play("out")
	
	tween_SE_volume(false)
	
	yield(animPlayer, "animation_finished")
	emit_signal("_out_finished")
	
	if new_scene:
		for _child in _2DWorld.get_children():
			_child.queue_free()
		new_scene = new_scene.instance()
		_2DWorld.add_child(new_scene)
		
		Globals.TitleScreen.change_page("HIDE")
	
	if back_in:
		yield(get_tree().create_timer(0.1), "timeout")
		_in()


func tween_SE_volume(_in=true):
	tween.stop_all()
	
	if _in:
		tween.interpolate_method(self, "change_SE_volume", -40.0, Globals.SEs_max_db,
		0.5, Tween.TRANS_SINE, Tween.EASE_IN)
	else:
		tween.interpolate_method(self, "change_SE_volume", Globals.SEs_max_db, -40.0,
		0.5, Tween.TRANS_SINE, Tween.EASE_OUT)

	tween.start()

func change_SE_volume(new_volume):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SoundEffects"), new_volume)


func change_title_page(page):
	_out(null)
	yield(self, "_out_finished")
	
	for _child in _2DWorld.get_children():
		_child.queue_free()
	
	Globals.TitleScreen.change_page(page)
	_in(null, false)
