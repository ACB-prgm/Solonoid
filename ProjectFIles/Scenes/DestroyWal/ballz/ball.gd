extends Control


onready var sprite = $Sprite
onready var tween = $Tween

var death_TSCN = preload("res://Scenes/Enemies/EnemyDeaths/Enemy_Death.tscn")
var dead := false


func _ready():
	set_process(false)


func die():
	if !dead:
		dead = true
		set_process(true)
		
		tween.interpolate_property(self, "rect_min_size",
		rect_min_size * 1.2, Vector2(.001, .001), 
		.1, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
		tween.interpolate_property($Sprite/Light2D, "energy",
		$Sprite/Light2D.energy * 2, 0.5, 
		.1, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
		tween.start()
		
		var death_ins = death_TSCN.instance()
		death_ins.shake = false
		death_ins.global_position = sprite.global_position
		death_ins.scale *= 0.3
		Globals._2DWorld.add_child(death_ins)


func _process(_delta):
	sprite.scale = rect_min_size/Vector2(50,50)


func _on_Tween_tween_all_completed():
		
	queue_free()
