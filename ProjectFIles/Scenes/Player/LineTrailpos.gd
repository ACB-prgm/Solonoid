extends Position2D


export var MAX_POINTS = 10
export var line_thickness = 10
export var line_gradient: Gradient
export var light_color = Color(0.33, 1, 0.98, 1)

onready var light = $Light2D
onready var line = $Line2D


func _ready():
	line.MAX_POINTS = MAX_POINTS
	line.gradient = line_gradient
	
	light.color = light_color
	


func set_thrust(thrust):
	light.energy = lerp(0.1, 0.5, thrust)
