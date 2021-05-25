extends Position2D


export var MAX_POINTS = 10

onready var light = $Light2D


func _ready():
	$Line2D.MAX_POINTS = MAX_POINTS


func set_thrust(thrust):
	light.energy = lerp(0.1, 0.5, thrust)
