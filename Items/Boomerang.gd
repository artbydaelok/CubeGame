extends "res://Projectile.gd"

func throw_boomerang(target):
	var offset = 30
	shoot_at(player.boss.translation + Vector3(rand_range(-offset, offset), 0, rand_range(-offset, offset)), 0)
	homing_target = target
	state = PROJECTILE_STATE.HOMING

func _process(delta):
	$MeshInstance.rotate_y(22 * delta)
	
func _on_Area_body_entered(body):
	if body.is_in_group("Enemy"):
		if state == PROJECTILE_STATE.HOMING:
			throw_boomerang(player)
	else:
		if body.is_in_group("Player") and homing_target == player:
			print("Returned Boomerang")
			queue_free()
