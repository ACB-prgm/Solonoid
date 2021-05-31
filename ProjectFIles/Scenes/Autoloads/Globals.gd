extends Node


var player
var camera

var _2DWorld
var TitleScreen
var current_mouse_pos := Vector2.ZERO


# AUDIO SETTINGS
onready var SEs_max_db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SoundEffects"))
onready var MUSIC_max_db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
