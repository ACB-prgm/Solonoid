extends Sprite


onready var tween = $Tween
onready var shader = get_material()

var player_TSCN = preload("res://Scenes/Player/Player.tscn")


func _ready():
	yield(Transitioner, "_in_finished")
	
	tween.interpolate_property(shader, "shader_param/progress", 1.0, 0.0, 
	1, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()


func _on_Tween_tween_all_completed():
	var p_ins = player_TSCN.instance()
	p_ins.global_position = global_position
	get_parent().call_deferred("add_child", p_ins)
	
	queue_free()
