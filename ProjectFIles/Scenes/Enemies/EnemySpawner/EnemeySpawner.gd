extends StaticBody2D


export var spawn_limit = 1
export var spawn_time = 5

onready var timer = $Timer

var screamer_TSCN = preload("res://Scenes/Enemies/Enemy_1/Enemy_1.tscn")
var spawned_enemies = 0


func _ready():
	timer.wait_time = spawn_time


func start_spawning():
	spawn_enemy()
	timer.start()

func stop_spawning():
	timer.stop()


func spawn_enemy():	
	var enemy_ins = screamer_TSCN.instance()
	enemy_ins.global_position = global_position
	enemy_ins.connect("enemy_died", self, "_on_enemy_died")
	get_parent().call_deferred("add_child", enemy_ins)
	
	spawned_enemies += 1


func _on_enemy_died():
	spawned_enemies -= 1
	spawned_enemies = clamp(spawned_enemies, 0, spawn_limit)


func _on_Timer_timeout():
	if spawned_enemies < spawn_limit:
		spawn_enemy()
