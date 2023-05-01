extends GridContainer

var inventory = preload("res://Inventory.tres")

func _ready():
	# Connects the signals for when items change
	# This signal comes from the inventory script
	inventory.connect("items_changed", self, "_on_items_changed")
	inventory.connect("active_changed", self, "_on_active_item_changed")
	update_inventory_display()
	
func update_inventory_display():
	# Loops through the inventory to update every item slot display in the inventory
	for item_index in inventory.items.size():
		update_inventory_slot_display(item_index)
	
func update_inventory_slot_display(item_index):
	# Updates an individual slot according to its index
	var inventorySlotDisplay = get_child(item_index)
	var item = inventory.items[item_index]
	inventorySlotDisplay.display_item(item)
	
func _on_items_changed(indexes):
	for item_index in indexes:
		update_inventory_slot_display(item_index)

func _on_active_item_changed(index):
	for slot in get_children().size():
		get_child(slot).set_active(false)
		
	var inventorySlotDisplay = get_child(index[0])
	inventorySlotDisplay.set_active(true)


func _unhandled_input(event):
		if event.is_action_released("ui_left_mouse"):
			if inventory.drag_data is Dictionary:
				inventory.set_item(inventory.drag_data.item_index, inventory.drag_data.item)
