extends Spatial

signal inventory_shuffling


func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		emit_signal("inventory_shuffling")
