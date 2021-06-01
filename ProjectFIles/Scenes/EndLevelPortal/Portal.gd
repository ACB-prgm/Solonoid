extends Area2D




func _on_Portal_body_entered(body):
	body.portal(false)
	$AnimationPlayer.play("bloop")
	
	Globals.camera.shake(1000, 5, 1000, 10)


func _on_AnimationPlayer_animation_finished(_anim_name):
	Transitioner.change_title_page("SCORE")
	Music._out()
