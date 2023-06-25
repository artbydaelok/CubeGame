extends Area

onready var player
	
	
enum ITEM {
	shotgun,
	spear,
	tennis,
	fire_extinguisher,
	molotov,
	pepper_spray,
	boomerang,
	throwing_axe,
	water_balloon
}

export(ITEM) var item
	
func _on_Item_body_entered(body):
	if body is Player:
		print("Item picked up")
		
		self.queue_free()
