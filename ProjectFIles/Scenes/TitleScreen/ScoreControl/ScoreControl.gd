extends Control


onready var tween = $Tween
onready var leftCrystal = $Lights_BG/Node2D/Crystal
onready var rightCrystal = $Lights_BG/Node2D/Crystal2
onready var levelLabel = $LevelLabel
onready var highscoreLabel = $VBoxContainer/HighScoreLabel
onready var scorelabel = $VBoxContainer/ScoreLabel
onready var timeValueLabel = $PanelContainer/CenterContainer/MultipliersGridContainer/TimevalueLabel
onready var timeMultiplierLabel = $PanelContainer/CenterContainer/MultipliersGridContainer/TimeMultiplierLabel
onready var attemptValueLabel = $PanelContainer/CenterContainer/MultipliersGridContainer/AttemptvalueLabel
onready var attemptMultiplierLabel = $PanelContainer/CenterContainer/MultipliersGridContainer/AttemptMultiplierLabel
onready var levelScoreLabel = $LevelScoreLabel
onready var nextLevelButton = $PanelContainer4/NextLevelButton
onready var typingSound = $TypingSound
onready var BEST_TIME = Globals.LEVELS.get(Globals.current_level).get("BEST_TIME")
onready var BASE_SCORE = Globals.LEVELS.get(Globals.current_level).get("BASE_SCORE")
onready var current_score = Globals.current_score
onready var current_level = Globals.current_level

var sound_playing := false
var time_value
var time_multi = 1
var attempt_multi = 1


func _ready():
	Globals.save_data()
	Transitioner.tween_SE_volume(false)
	nextLevelButton._set_disabled(true)
	levelLabel.set_text(current_level)
	
	highscoreLabel.text = "high score : %s" % Globals.high_score
	scorelabel.text = "score : %s" % current_score
	
	if Globals.attempt_success:
		Music._in("SCORE")
		levelScoreLabel.text = "level score : %s" % BASE_SCORE
	#	var center_levelLabel = levelLabel.rect_position + levelLabel.rect_size/2.0
	#	leftCrystal.global_position = Vector2(center_levelLabel.x - levelLabel.rect_size.x/2.0 - 100, center_levelLabel.y)
	#	rightCrystal.global_position = Vector2(center_levelLabel.x + levelLabel.rect_size.x/2.0 + 100, center_levelLabel.y)
		
		yield(Transitioner, "_in_finished")
		
		tween.interpolate_property(self, "time_value", 0.0, Globals.current_score_time, 
		1, Tween.TRANS_SINE, Tween.EASE_OUT)
		tween.start()
		
		attemptValueLabel.text = "00"
		yield(tween, "tween_all_completed")
		
		timeMultiplierLabel.rect_pivot_offset = timeMultiplierLabel.rect_size/2.0
		tween.interpolate_property(timeMultiplierLabel, "rect_scale", Vector2(2,2), 
		timeMultiplierLabel.rect_scale, 0.5, Tween.TRANS_SINE, Tween.EASE_IN)
		tween.start()
		yield(tween, "tween_all_completed")
		
		attemptValueLabel.text = str(Globals.current_attempt)
		yield(get_tree().create_timer(0.5), "timeout")
		
		var attempt = Globals.current_attempt
		if attempt == 1:
			attempt_multi = 3
		elif attempt == 2:
			attempt_multi = 2
		elif attempt == 3:
			attempt_multi = 1.25
		else:
			attempt_multi = 1
		attemptMultiplierLabel.text = "x%s" % attempt_multi
		attemptMultiplierLabel.rect_pivot_offset = attemptMultiplierLabel.rect_size/2.0
		tween.interpolate_property(attemptMultiplierLabel, "rect_scale", Vector2(2,2), 
		attemptMultiplierLabel.rect_scale, 0.5, Tween.TRANS_SINE, Tween.EASE_IN)
		tween.start()
		
		yield(tween, "tween_all_completed")
		
		tween.interpolate_property(self, "BASE_SCORE", 0.0, BASE_SCORE * time_multi * attempt_multi, 
		1, Tween.TRANS_SINE, Tween.EASE_OUT)
		tween.start()
		
		yield(tween, "tween_all_completed")
		
		levelScoreLabel.rect_pivot_offset = levelScoreLabel.rect_size/2.0
		tween.interpolate_property(levelScoreLabel, "rect_scale", Vector2(2,2), 
		levelScoreLabel.rect_scale, 0.5, Tween.TRANS_SINE, Tween.EASE_IN)
		tween.start()
		
		yield(tween, "tween_all_completed")
		scorelabel.text = "score : %s + %s" % [Globals.current_score, BASE_SCORE]
		nextLevelButton._set_disabled(false)
	
	else:
		Music._in("FAIL")
		$PanelContainer4.hide()

func _on_Tween_tween_step(_object, key, _elapsed, _value):
	if key == ":time_value":
		timeValueLabel.text = str(stepify(time_value, 0.01))
		
		if time_value < BEST_TIME:
			time_multi = 3
		elif time_value < BEST_TIME * 1.25:
			time_multi = 2
		elif time_value < BEST_TIME * 1.5:
			time_multi = 1.5
		elif time_value < BEST_TIME * 1.75:
			time_multi = 1.25
		else:
			time_multi = 1
		
		timeMultiplierLabel.text = "x%s" % time_multi
		
		play_blip_sound()
	
	elif key == ":BASE_SCORE":
		levelScoreLabel.text = "level score : %s" % str(int(BASE_SCORE))
		
		play_blip_sound()
	
	elif key == ":current_score":
		scorelabel.text = "score : %s" % str(int(current_score))
		
		if current_score > Globals.high_score:
			highscoreLabel.text = "high score : %s" % str(int(current_score))
			Globals.high_score = current_score
		
		play_blip_sound()


func play_blip_sound():
	if !sound_playing:
		typingSound.pitch_scale = 2 + rand_range(-.05, .05)
		typingSound.play()
		
		yield(get_tree().create_timer(.3), "timeout")
		sound_playing = false


func _on_NextLevelButton_TextButton_Pressed():
	tween.interpolate_property(self, "current_score", current_score, current_score + BASE_SCORE, 
	1, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()
	
	yield(tween, "tween_all_completed")
	typingSound.volume_db = 0
	
	scorelabel.rect_pivot_offset = scorelabel.rect_size/2.0
	tween.interpolate_property(scorelabel, "rect_scale", Vector2(2,2), 
	scorelabel.rect_scale, 0.5, Tween.TRANS_SINE, Tween.EASE_IN)
	tween.start()
	
	Globals.current_score = current_score
	Globals.save_data()
	
	var level_int = int(current_level.right(-1))
	var next_level = current_level.replace(str(level_int), str(level_int + 1))
	
	if Globals.LEVELS.has(next_level):
		Globals.current_level = next_level
		Transitioner._out(Globals.LEVELS.get(next_level).get("SCENE"), true)
		Music._out()
	else:
		Transitioner.change_title_page("TITLE")
		Music._out()


func _on_RetryLevelButton2_TextButton_Pressed():
	Globals.current_attempt += 1
	Transitioner._out(Globals.LEVELS.get(current_level).get("SCENE"), true)
	Music._out()


func _on_TextButton_TextButton_Pressed():
	Transitioner.change_title_page("TITLE")
	Music._out()
