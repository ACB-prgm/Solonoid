extends StaticBody2D


onready var tween = $Tween
onready var raycast = $RayCast2D
onready var laser = $Line2D
onready var gen_light = $Light2D
onready var lightSprite = $LightSprite
onready var particles = $Particles2D
onready var endLight = $Particles2D/EndLight
onready var coll_shape = $CollisionShape2D
onready var hurtbox_coll_shape = $CollisionShape2D/Area2D/CollisionShape2D


func _ready():
	raycast.force_raycast_update()
	
	if raycast.is_colliding():
		var coll_point = raycast.get_collision_point()
		laser.points[1] = to_local(coll_point)
		particles.global_position = coll_point
		
		var shape = RectangleShape2D.new()
		var half_way_amount = (global_position - coll_point)/2.0
		var center_point = global_position - half_way_amount
		shape.extents.x = half_way_amount.rotated(rotation).x
		
		coll_shape.shape = shape
		shape = shape.duplicate()
		shape.extents.y = 15
		hurtbox_coll_shape.shape = shape
		
		coll_shape.global_position = center_point
		
		raycast.set_deferred("enabled", false)


func _on_generator_killed():
	coll_shape.set_deferred("disabled", true)
	hurtbox_coll_shape.set_deferred("disabled", true)
	
	tween.interpolate_property(gen_light, "energy", 0.5, 0.0, 
	1.0, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	tween.interpolate_property(laser, "modulate:a", 1.0, 0.0, 
	1.0, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	tween.interpolate_property(endLight, "energy", 0.5, 0.0, 
	1.0, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	tween.interpolate_property(particles, "modulate:a", 1.0, 0.0, 
	1.0, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	tween.interpolate_property(lightSprite, "modulate:a", 1.0, .8, 
	1.0, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	
	tween.start()


func _on_generator_restarted():
	
	tween.interpolate_property(gen_light, "energy", 0.0, 0.5, 
	1.0, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	tween.interpolate_property(laser, "modulate:a", 0.0, 1.0, 
	1.0, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	tween.interpolate_property(endLight, "energy", 0.0, 0.5, 
	1.0, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	tween.interpolate_property(particles, "modulate:a", 0.0, 1.0, 
	1.0, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	tween.interpolate_property(lightSprite, "modulate:a", 0.8, 1.0, 
	1.0, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	
	tween.start()
	
	yield(tween, "tween_all_completed")
	
	coll_shape.set_deferred("disabled", false)
	hurtbox_coll_shape.set_deferred("disabled", false)


func _on_Area2D_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage()
