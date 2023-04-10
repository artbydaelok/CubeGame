extends Area

###########
###    MAKE AN ARRAY THAT CONTAINS DIRECTIONS FOR WALL TO SPAWN
###########

var direction = Vector3.BACK

export var wall_speed = 3

func _on_FireWall_body_entered(body):
	if body is Player:
		var health = body.get_node("Health")
		health.set_current(health.current - 1)

func _process(delta):
	self.translation += direction * wall_speed * delta
	#self.get_global_transform().basis.z * wall_speed * delta
