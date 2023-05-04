extends Position3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = $"../../../.."
	player.inventory.connect("active_changed", self, "update_side")
	if player.using_numbers:
		visible = false
	#update_side(0)


func update_side(_item_index):
	var item = player.inventory.get_item(get_index())
	get_child(0).texture = item.texture
