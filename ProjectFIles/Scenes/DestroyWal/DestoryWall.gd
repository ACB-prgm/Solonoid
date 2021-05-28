tool
extends StaticBody2D


export var num_walls = 2 setget set_wall_height
export var wall_width = 250 setget set_wall_width
export var balls_per_wall = 10

onready var collshape = $CollisionShape2D
onready var ball_vbox = $CollisionShape2D/VBoxContainer
onready var light = $CollisionShape2D/Light2D
onready var balls = balls_per_wall * num_walls

var ball_TSCN = preload("res://Scenes/DestroyWal/ballz/ball.tscn")


func _ready():
	if !Engine.editor_hint:
		set_ball_vbox()
		create_walls()


func set_ball_vbox():
	collshape.shape.extents.y = num_walls * 25 # 1/2 size of one ball + hbox separation
	ball_vbox.rect_size = collshape.shape.extents * 2.0
	ball_vbox.rect_pivot_offset = ball_vbox.rect_size / 2.0
	ball_vbox.rect_position = ball_vbox.rect_pivot_offset * -1
	
	light.scale = collshape.shape.extents / 10


func set_wall_width(new_val):
	if Engine.editor_hint:
		if new_val < wall_width:
			wall_width -= 25
		else:
			wall_width += 25

		self.balls_per_wall = int(wall_width / 25)
		collshape.shape.extents.x = wall_width + balls_per_wall * 1.5 # spacing of hbx
		collshape.shape.extents.y = num_walls * 25


func set_wall_height(new_val):
	num_walls = new_val
	collshape.shape.extents.y = num_walls * 25


func create_walls():
	for _wall in range(num_walls):
		var ball_hbox := HBoxContainer.new()
		ball_hbox.alignment = BoxContainer.ALIGN_CENTER
		ball_vbox.add_child(ball_hbox)
		
		for _ball in range(balls_per_wall):
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
