extends Area2D




func _on_Portal_body_entered(body):
	body.portal(false)
	$AnimationPlayer.play("bloop")
	
	Globals.camera.shake(1200, 5, 1200, 7)


func _on_AnimationPlayer_animation_finished(_anim_name):
	Globals.attempt_success = true
	Transitioner.change_title_page("SCORE")
	Music._out()
