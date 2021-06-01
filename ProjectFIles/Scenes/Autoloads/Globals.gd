extends Node


var player
var camera
var _2DWorld
var TitleScreen
var high_score := 750

var current_score := 0
var current_score_time := 0.0
var current_attempt := 1
var current_level := "LEVEL 1"
var LEVELS = {
	"LEVEL 1" : {
		"SCENE" : preload("res://Scenes/Levels/Level1/Level_1.tscn"),
		"BEST_TIME" : 20,
		"BASE_SCORE" : 100
	},
	"LEVEL 2" : {
		"SCENE" : null
	}
}

# UX SETTINGS ——————————————————————————————————————————————————————————————————
var shoot_on_aim := true
var layout_preset = "DEFAULT"


# AUDIO SETTINGS ———————————————————————————————————————————————————————————————
onready var SEs_max_db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SoundEffects"))
onready var MUSIC_max_db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))


# FUNCTIONS ————————————————————————————————————————————————————————————————————
func _ready():
	OS.center_window()
