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
onready var BEST_TIME = Globals.LEVELS.get(Globals.current_level).get("BEST_TIME")
onready var BASE_SCORE = Globals.LEVELS.get(Globals.current_level).get("BASE_SCORE")
onready var current_score = Globals.current_score

var time_value
var time_multi = 1
var attempt_multi = 1


func _ready():
	Music._in("SCORE")
	Transitioner.tween_SE_volume(false)
	levelLabel.text = Globals.current_level
#	var center_levelLabel = levelLabel.rect_position + levelLabel.rect_size/2.0
#	leftCrystal.global_position = Vector2(center_levelLabel.x - levelLabel.rect_size.x/2.0 - 100, center_levelLabel.y)
#	rightCrystal.global_position = Vector2(center_levelLabel.x + levelLabel.rect_size.x/2.0 + 100, center_levelLabel.y)
	
	highscoreLabel.text = "high score : %s" % Globals.high_score
	scorelabel.text = "score : %s" % current_score
	
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


func _on_Tween_tween_step(_object, key, _elapsed, _value):
	if key == ":time_value":
		timeValueLabel.text = str(stepify(time_value, 0.1))
		
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
	
	elif key == ":BASE_SCORE":
		levelScoreLabel.text = "level score : %s" % str(int(BASE_SCORE))
	
	elif key == ":current_score":
		scorelabel.text = "score : %s" % str(int(current_score))


func _on_NextLevelButton_TextButton_Pressed():
	tween.interpolate_property(self, "current_score", current_score, current_score + BASE_SCORE, 
	1, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()
	
	yield(tween, "tween_all_completed")
	
	scorelabel.rect_pivot_offset = scorelabel.rect_size/2.0
	tween.interpolate_property(scorelabel, "rect_scale", Vector2(2,2), 
	scorelabel.rect_scale, 0.5, Tween.TRANS_SINE, Tween.EASE_IN)
	tween.start()
	
	Globals.current_score = current_score
	
	print("change to lvl 2")


func _on_RetryLevelButton2_TextButton_Pressed():
	Globals.current_attempt += 1
	Transitioner._out("res://Scenes/Levels/Level1/Level_1.tscn", true)
	Music._out()


func _on_TextButton_TextButton_Pressed():
	Transitioner.change_title_page("TITLE")
	Music._out()
