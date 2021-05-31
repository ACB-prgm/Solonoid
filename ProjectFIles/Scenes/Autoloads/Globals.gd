extends Node


var player
var camera

var _2DWorld
var TitleScreen
var current_mouse_pos := Vector2.ZERO

# UX SETTINGS
var shoot_on_aim := false


# AUDIO SETTINGS
onready var SEs_max_db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SoundEffects"))
onready var MUSIC_max_db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))


func _ready():
	OS.center_window()
