extends Resource
class_name Inventory

# Set drag data to null so that when the game starts, there isn't already data being dragged
var drag_data = null

var active_item_index = 1

# Declare the signal for when items change
signal items_changed(indexes)
signal active_changed(index)
signal cooldown_reset()
signal item_used

# Set up the inventory array of resources
export (Array, Resource) var items = [
	null, null, null, null, null, null
]

func set_active_item(item_index):
	active_item_index = item_index
	emit_signal("active_changed" , [item_index])

func get_active_item_index():
	return active_item_index

func get_active_item():
	return items[active_item_index]

func get_item(item_index):
	return items[item_index]
	
func get_items_array():
	return items
	
func get_item_count():
	return items.size()

func set_item(item_index, item):
	# Save a reference to the item previously at this slot
	var previousItem = items[item_index]
	# Set the item slot to the new item
	items[item_index] = item
	# Emit signal when items change, and pass the index that was changed
	emit_signal("items_changed", [item_index])
	return previousItem
	
func reset_item_cooldown(item_index):
	get_item(item_index).on_cooldown = false
	emit_signal("cooldown_reset")
	
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
	
func swap_items_by_ref(item, target_item, item_index):
	#var temp_target = target_item
	#target_item = item
	#item = temp_target
	
	set_item(item_index, item)
	
	emit_signal("items_changed", [item_index])
	
func use_item():
	emit_signal("item_used", items[active_item_index].cooldown)
	
func remove_item(item_index):
	# Save a reference to the item previously at this slot
	var previousItem = items[item_index]
	# Set the item slot to null
	items[item_index] = null
	# Emit signal when items change, and pass the index that was changed
	emit_signal("items_changed", [item_index])
	return previousItem
