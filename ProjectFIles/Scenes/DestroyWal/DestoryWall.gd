tool
extends StaticBody2D


export var balls = 10
export var shape_extents = Vector2(250, 100) setget set_shape_extents

onready var collshape = $CollisionShape2D
onready var ball_vbox = $CollisionShape2D/VBoxContainer
onready var balls_per_hbox = int(collshape.shape.extents.x / 50)
onready var num_walls = balls/balls_per_hbox

var ball_TSCN = preload("res://Scenes/DestroyWal/ballz/ball.tscn")


func _ready():
	if !Engine.editor_hint:
		set_ball_vbox()
		create_walls()


func set_ball_vbox():
	collshape.shape.extents.y = num_walls * 50
	ball_vbox.rect_size = collshape.shape.extents * 2.0
	ball_vbox.rect_pivot_offset = ball_vbox.rect_size / 2.0
	ball_vbox.rect_position = ball_vbox.rect_pivot_offset * -1


func set_shape_extents(new_val):
	shape_extents = new_val
	collshape.shape.extents = new_val


func create_walls():
	if balls % balls_per_hbox != 0:
		num_walls += 1
	
	for _wall in range(num_walls):
		var ball_hbox := HBoxContainer.new()
		ball_hbox.alignment = BoxContainer.ALIGN_CENTER
		ball_vbox.add_child(ball_hbox)
		
		for _ball in range(balls_per_hbox):
			if balls > 0:
				var ball_ins = ball_TSCN.instance()
				ball_hbox.add_child(ball_ins)
				balls -= 1
			else:
				break


func take_damage(_damage, _dir):
	var hboxes = ball_vbox.get_children()
	
	if hboxes:
		var front_balls = hboxes[-1].get_children()
		var num_balls = front_balls.size()
		
		front_balls[num_balls/2 - 1].die()
		
		if num_balls <= 1:
			hboxes[-1].queue_free()
			if ball_vbox.get_child_count() == 1:
				die()
	else: # All balls desroyed, do nothing (should never run)
		pass


func die():
	queue_free()
