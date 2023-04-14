extends Resource
class_name Inventory

# Set drag data to null so that when the game starts, there isn't already data being dragged
var drag_data = null

# Declare the signal for when items change
signal items_changed(indexes)

# Set up the inventory array of resources
export (Array, Resource) var items = [
	null, null, null, null, null, null
]

func set_item(item_index, item):
	# Save a reference to the item previously at this slot
	var previousItem = items[item_index]
	# Set the item slot to the new item
	items[item_index] = item
	# Emit signal when items change, and pass the index that was changed
	emit_signal("items_changed", [item_index])
	return previousItem
	
	
func swap_items(item_index, target_item_index):
	# We the get a ref to the first item we want to swap out in the inventory
	var targetItem = items[target_item_index]
	# And a ref to the second one
	var item = items[item_index]
	# Then we set them to each other
	items[target_item_index] = item
	items[item_index] = targetItem
	# Finally we emit the signal for items changed along with the indexes of those items
	emit_signal("items_changed", [item_index, target_item_index])
	
func remove_item(item_index):
	# Save a reference to the item previously at this slot
	var previousItem = items[item_index]
	# Set the item slot to null
	items[item_index] = null
	# Emit signal when items change, and pass the index that was changed
	emit_signal("items_changed", [item_index])
	return previousItem
