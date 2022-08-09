extends Node


var player
var GamePad_connected = null
var camera
var _2DWorld
var TitleScreen
var high_score := 000

var current_score := 0
var current_score_time := 0.0
var current_attempt := 1
var attempt_success := false
var current_level := ""
var LEVELS = {
	"LEVEL 1" : {
		"SCENE" : preload("res://Scenes/Levels/Level1/Level_1.tscn"),
		"BEST_TIME" : 18,
		"BASE_SCORE" : 100
	},
	"LEVEL 2" : {
		"SCENE" : preload("res://Scenes/Levels/Level2/Level2.tscn"),
		"BEST_TIME" : 17,
		"BASE_SCORE" : 100
	},
	"LEVEL 3" : {
		"SCENE" : preload("res://Scenes/Levels/Level3/Level3.tscn"),
		"BEST_TIME" : 25,
		"BASE_SCORE" : 150
	},
	"LEVEL 4" : {
		"SCENE" : preload("res://Scenes/Levels/Level4/Level4.tscn"),
		"BEST_TIME" : 21,
		"BASE_SCORE" : 150
	}
}


func reset_run_stats() -> void:
	current_score = 0
	current_score_time = 0.0
	current_attempt = 1
	attempt_success = false
	current_level = ""


# UX SETTINGS ——————————————————————————————————————————————————————————————————
var shoot_on_aim := true
var layout_preset = "DEFAULT"


# AUDIO SETTINGS ———————————————————————————————————————————————————————————————
onready var SEs_max_db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SoundEffects"))
onready var MUSIC_max_db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))


# FUNCTIONS ————————————————————————————————————————————————————————————————————
func _ready():
	OS.center_window()
	load_data()


# SAVE/LOAD
const SAVE_DIR = 'user://saves/'

var save_path = SAVE_DIR + 'save.dat'


func save_data():
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	
	var file = File.new()
	var error = file.open_encrypted_with_pass(save_path, File.WRITE, 'abigail')
	if error == OK:
		var data = {
			"high_score" : high_score,
			"shoot_on_aim" : shoot_on_aim,
			"layout_preset" : layout_preset
		}
		
		file.store_var(data)
		file.close()

func load_data():
	var file = File.new()
	if file.file_exists(save_path):
		var error = file.open_encrypted_with_pass(save_path, File.READ, 'abigail')
		if error == OK:
			var data = file.get_var()
			
			high_score = data.get("high_score")
			shoot_on_aim = data.get("shoot_on_aim")
			layout_preset = data.get("layout_preset")
			
			file.close()
