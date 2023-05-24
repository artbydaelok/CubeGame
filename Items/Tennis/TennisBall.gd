extends "res://Projectile.gd"

var has_bounced = false

func _process(_delta):
	if translation.y < -10:
		queue_free()
	
func _on_Area_body_entered(body):
	if body.is_in_group("Enemy"):
		if destroy_timer.is_stopped() == false:
			destroy_timer.stop()
			destroy_timer.start(-1)
		has_bounced = true
		lob_at(player, 4, 1)
		body.take_damage(damage)
		
	elif body.is_in_group("Player") and has_bounced:
		$Arc.stop(self)
		linear_velocity = Vector3.ZERO
		is_lobbed = false
		has_bounced = false
		state = PROJECTILE_STATE.DEFAULT
		shoot_at(player.boss.translation, 0)
		#player.tennis_racket.look_at_boss = false
		player.tennis_racket.anim_player.play("Swing")
		


func _on_Arc_tween_completed(object, key):
	pass


func _on_Arc_tween_all_completed():

	state = PROJECTILE_STATE.DEFAULT
	# We zero out the velocity
	linear_velocity = Vector3.ZERO
	# and then apply a central impulse using the previous known direction while lobbed
	# this gives the impression that the projectile was still moving. 
	apply_central_impulse(last_direction * 8)
