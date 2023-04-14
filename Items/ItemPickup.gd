extends Area

onready var player
	
func _on_Item_body_entered(body):
	if body is Player:
		print("Item picked up")
		self.queue_free()
