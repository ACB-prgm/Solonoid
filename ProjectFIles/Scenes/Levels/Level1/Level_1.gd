extends Node2D


export var LEVEL = "LEVEL 1"


func _ready():
	Transitioner._in()
	Globals.attempt_success = false
	Music._in("GAME")
	
	prints(Globals.current_level, LEVEL)
	if Globals.current_level == LEVEL:
		Globals.current_attempt += 1
	else:
		Globals.current_level = LEVEL
		Globals.current_attempt = 1
