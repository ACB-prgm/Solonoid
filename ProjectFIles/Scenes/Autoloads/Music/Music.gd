extends Node

const MUTE_VOL = -35
const SONGS = {
	"TITLE" : ["res://Audio/Music/UI/DOS-88 - Underground.ogg"],
	"GAME" : [
		"res://Audio/Music/Game/DOS-88 - Dark Ascent.ogg",
		"res://Audio/Music/Game/DOS-88 - Brute Force.ogg",
		"res://Audio/Music/Game/DOS-88 - Captain\'s Log.ogg",
		"res://Audio/Music/Game/D0S-88 - Raging Inferno.ogg",
		"res://Audio/Music/Game/DOS-88 - Double Tap.ogg",
	],
	"END_LEVEL" : ["res://Audio/Music/UI/DOS-88 - City Stomper.ogg"]
}

onready var tween = $Tween
onready var audioPlayer = $AudioStreamPlayer


#func _ready():
#	randomize()


func _in(song, time=0.5):
	tween.stop_all()
	
	
	song = SONGS.get(song)
	if song.size() > 1:
		song.shuffle()
	song = load(song[0])
	
	audioPlayer.stream = song
	audioPlayer.playing = true
	
	tween.interpolate_method(self, "change_MUSIC_volume", 
	MUTE_VOL, Globals.MUSIC_max_db, time, Tween.TRANS_SINE, Tween.EASE_IN)
	tween.start()


func _out(time=0.5):
	tween.stop_all()
	
	tween.interpolate_method(self, "change_MUSIC_volume", 
	Globals.MUSIC_max_db, MUTE_VOL, time, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()


func change_MUSIC_volume(new_volume):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), new_volume)


func _on_Tween_tween_completed(_object, _key):
	if AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")) == MUTE_VOL:
		audioPlayer.playing = false
