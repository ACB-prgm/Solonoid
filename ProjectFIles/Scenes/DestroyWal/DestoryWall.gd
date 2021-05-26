extends StaticBody2D


export var balls = 10

onready var collshape = $CollisionShape2D
onready var ball_vbox = $CollisionShape2D/VBoxContainer

var ball_TSCN = preload("res://Scenes/DestroyWal/ballz/ball.tscn")


func _ready():
	set_ball_vbox()


func set_ball_vbox():
	ball_vbox.rect_size = collshape.shape.extents * 2.0
	ball_vbox.rect_pivot_offset = ball_vbox.rect_size / 2.0
	ball_vbox.rect_position = ball_vbox.rect_pivot_offset * -1
	


func create_wall():
	var count := 0
	var ball_hbox := HBoxContainer.new()
	ball_hbox.alignment = BoxContainer.ALIGN_CENTER
	
	for ball in range(balls):
		
		if count % 10 == 0:
			ball_vbox.add_child(ball_hbox)
		else:
			ball_hbox.add_child(ball_TSCN.instance())

		count += 1

