extends StaticBody2D


export var restart_time := 5.0
export var can_restart := true

onready var timer = $Timer
onready var tween = $Tween
onready var animPlayer = $AnimationPlayer
onready var runSound = $RunningSound
onready var powerdownSound = $PowerDownSound

var dead := false
var health := 3

signal generator_killed
signal generator_restarted


func _ready():
	timer.wait_time = restart_time


func _physics_process(_delta):
	run_sounds()


func run_sounds():
	if !dead:
		var target = Globals.player
		if target and is_instance_valid(target):
			var nearness = 400/global_position.distance_to(target.global_position)
			nearness = clamp(nearness, 0.0, 1.0)
			runSound.volume_db = lerp(-30.0, -5.0, nearness)


func _on_HitboxArea2D_area_entered(_area):
	if !dead:
		Globals.camera.shake(50, 0.15, 100, 10)
		
		tween.interpolate_property($Light2D, "energy", 1.1, 0.5, 
		.2, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
		tween.interpolate_property($Light2D2, "modulate:a", 1.1, 0.5, 
		.2, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
		tween.interpolate_property(runSound, "pitch_scale", .7, 1, 
		.3, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
		tween.start()
		
		health -= 1
		
		if health <= 0:
			die()


func die():
	if !dead:
		dead = true
		
		emit_signal("generator_killed")
		timer.start()
		animPlayer.stop()
		boot()


func _on_Timer_timeout():
	if can_restart:
		emit_signal("generator_restarted")
		dead = false
		health = 3
		boot(true)
		
		yield(tween, "tween_all_completed")
		
		animPlayer.play("Running")


func boot(up=false):
	var start = 1.0
	var end = 0.7
	
	if up:
		runSound.play()
		tween.interpolate_property(runSound, "pitch_scale", 0.7, 1, 
		1, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
		start = 0.7
		end = 1.0
	else:
		runSound.stop()
		powerdownSound.play()
	
	tween.interpolate_property($LightSprite, "modulate:a", start, end, 
	1, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	tween.interpolate_property($UnderLight, "modulate:a", start, end, 
	1, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	tween.interpolate_property($Light2D, "energy", start, end, 
	1, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	tween.interpolate_property($Light2D2, "energy", start, end, 
	1, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	
	tween.start()
