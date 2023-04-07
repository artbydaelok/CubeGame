extends Area

var directions = [Vector3.FORWARD, Vector3.BACK, Vector3.LEFT, Vector3.RIGHT]

func _ready():
	randomize()
	
func _on_Hitbox_body_entered(body):
	if body is Player:
		var health = body.get_node("Health")
		health.set_current(health.current - 1)
		# Force player to move to another tile.
		body.roll(directions[randi() % directions.size()])
