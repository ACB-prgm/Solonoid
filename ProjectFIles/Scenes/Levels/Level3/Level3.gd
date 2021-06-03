extends "res://Scenes/Levels/Level1/Level_1.gd"


onready var spawners = $Spawners


func _on_EnemyDetectionArea2D_body_entered(_body):
	$EnemyDetectionArea2D.queue_free()
	for spawner in spawners.get_children():
		spawner.start_spawning()



func _on_BarrierArea2D_body_entered(body):
	if body.has_method("die"):
		body.die()
