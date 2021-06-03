extends Control


const RADIUS = 100

onready var highscoreLabel = $HighScoreLabel

var dir: Vector2
var center := Vector2(3840,2160)/2.0
var scalar: float
var labels


func _ready():
	highscoreLabel.modulate = Color(1,1,1,0)
	
	Transitioner.tween_SE_volume(false)
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
	
	if Globals.high_score:
		yield(Transitioner, "_in_finished")
		highscoreLabel.text = "high score : %s" % Globals.high_score
		var tween = Tween.new()
		add_child(tween)
		tween.interpolate_property(highscoreLabel, "modulate", Color(1,1,1,0), 
		Color(1,1,1,1), .8, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
		tween.start()
		yield(tween, "tween_all_completed")
		tween.queue_free()


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
	print(Globals.LEVELS.get("LEVEL 1").get('SCENE'))
	Transitioner._out(Globals.LEVELS.get("LEVEL 1").get('SCENE'), true)
	Music._out()
	
	set_process(false)


func _on_ControlsButton_TextButton_Pressed():
	Transitioner.change_title_page("CONTROLS")
