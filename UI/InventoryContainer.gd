extends ColorRect

var inventory = preload("res://Inventory.tres")

func can_drop_data(_position, data):
	# This function returns true if the data being dragged is an item
	return data is Dictionary and data.has("item")
	
func drop_data(_position, data):
	# This actually sets the item when it is dropped
	inventory.set_item(data.item_index, data.item)
