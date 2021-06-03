extends Node2D


export var line_length = 500
export var spin_left = true

onready var spinnerArea = $Spinner
onready var collshape = $Spinner/CollisionShape2D
onready var rightLine = $Spinner/RightLine2D
onready var leftLine = $Spinner/LeftLine2D

var spin = -2

func _ready():
	rightLine.points[1].x = line_length
	leftLine.points[1].x = line_length
	
	var range_shape = RectangleShape2D.new()
	range_shape.extents = Vector2(line_length - 30, 10)
	collshape.set_shape(range_shape)
	
	if !spin_left:
		spin = 2
		rightLine.scale.y *= -1
		leftLine.scale.y *= -1


func _physics_process(delta):
	spinnerArea.rotation += spin * delta


func set_line_length(length):
	line_length = length
	
	rightLine.points[1].x = line_length
	leftLine.points[1].x = line_length
	
	collshape.shape.extents = Vector2(line_length - 30, 10)


func _on_Spinner_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage()
