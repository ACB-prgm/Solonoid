extends KinematicBody2D


const MAX_SPEED = 800
const STEER_FORCE = 5

var desired: Vector2
var velocity = Vector2.ZERO
var target
var acceleration:Vector2

func _ready():
	target = Globals.player


func seek():
	var steer = Vector2.ZERO
	if target:
		var desired = global_position.direction_to(target.global_position) * MAX_SPEED
		steer = (desired - velocity).normalized() * STEER_FORCE
	return steer

func _physics_process(delta):
	acceleration += seek()
	velocity += acceleration
	velocity = velocity.clamped(MAX_SPEED)
	rotation = velocity.angle()
	move_and_slide(velocity)
