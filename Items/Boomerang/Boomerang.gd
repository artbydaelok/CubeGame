extends "res://Projectile.gd"

func throw_boomerang(target):
	var offset = 25
	acceleration = 1
	#acceleration = 0
	shoot_at(player.target.translation + Vector3(rand_range(-offset, offset), 0, rand_range(-offset, offset)), 0)
	homing_target = target
	$HomingStart.start()
	
func _process(delta):
	$MeshInstance.rotate_y(22 * delta)
	
func _on_Area_body_entered(body):
	if body.is_in_group("Enemy"):
		body.take_damage(damage)
		if state == PROJECTILE_STATE.HOMING:
			throw_boomerang(player)
	else:
		if body.is_in_group("Player") and homing_target == player:
			body.inventory.reset_item_cooldown(body.inventory.active_item_index)
			queue_free()


func _on_HomingStart_timeout():
	state = PROJECTILE_STATE.HOMING
