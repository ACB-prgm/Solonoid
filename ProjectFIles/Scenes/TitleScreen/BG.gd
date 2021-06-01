extends Sprite


const RADIUS = 100

var dir: Vector2
var center := Vector2(3840,2160)/2.0
var scalar: float


func _ready():
	show()

func _process(_delta):
	var mouse_pos = get_global_mouse_position()
	dir = mouse_pos.direction_to(center)
	scalar = mouse_pos.distance_to(center)
	scalar = clamp(scalar, 0, RADIUS)
	
	global_position = lerp(global_position, center + dir * scalar, scalar/RADIUS)
