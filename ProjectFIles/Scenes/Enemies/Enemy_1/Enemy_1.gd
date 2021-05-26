extends KinematicBody2D


export var speed = 800
export var steer_force = 200.0

onready var repelTimer = $RepelTimer

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var repel = Vector2.ZERO
var target = null


func _ready():
	randomize()
	target = Globals.player

func seek():
	var steer = Vector2.ZERO
	if target:
		var desired = global_position.direction_to(target.global_position) * speed
		steer = (desired - velocity).normalized() * steer_force
	return steer

func _physics_process(delta):
	acceleration += seek()
	velocity += acceleration * delta + repel
	velocity = velocity.clamped(speed)
	rotation = velocity.angle()
	move_and_slide(velocity)



func _on_RepelArea_area_entered(area):
	repel = area.global_position.direction_to(global_position) * rand_range(50, 100)
	repelTimer.wait_time = rand_range(0.3, 0.6)
	repelTimer.start()


func _on_RepelTimer_timeout():
	repel = Vector2.ZERO
