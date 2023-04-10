extends Area



func _on_FlameTile_body_entered(body):
	if body is Player:
		var health = body.get_node("Health")
		health.set_current(health.current - 1)
		queue_free()
