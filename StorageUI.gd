extends Control

var inventory = preload("res://Inventory.tres")
var storage = preload("res://Storage.tres")

const item_display = preload("res://ItemDisplay.tscn")

var inventory_items 
var storage_items

var swapped = false
var swapping = false
var temp_swap
var temp_index
var temp_owner


func _ready():
	display_ui()

func display_storage():
	# Set a variable for the array of items inside the storage
	storage_items = storage.get_items_array()
	var _index = 0
	
	# Clear children before adding them
	for child in $VBoxContainer/HBoxContainer/StorageContainer/ItemsContainer.get_children():
		child.queue_free()
	
	for item in storage_items:
		# For each item, obtain the information for icon, name and description
		var _name = item.name
		var _desc = item.description
		var _icon = item.texture
		
		# Perform function on item display where it displays all of this information 
		set_up_icon(item, _index, $VBoxContainer/HBoxContainer/StorageContainer/ItemsContainer)
		
		_index += 1
		
		
func display_ui():
	display_storage()
	display_inventory()
func display_inventory():

	### STILL NEEDS THE FOLLOWING
	# DISPLAY INVENTORY
	# BEING ABLE TO SWAP BETWEEN INVENTORY AND STORAGE
	
	
	inventory_items = inventory.get_items_array()
	var _index = 0
	
	for child in $VBoxContainer/Inventory/VBoxContainer/InventoryContainer.get_children():
		child.queue_free()	

	for item in inventory_items:
		if item != null:
			# For each item, obtain the information for icon, name and description
#			var _name = item.name
#			var _desc = item.description
#			var _icon = item.texture
			
			# Perform function on item display where it displays all of this information 
			set_up_icon(item, _index, $VBoxContainer/Inventory/VBoxContainer/InventoryContainer)
			
		_index += 1

func set_up_icon(item, index, _owner):		
	# Instance an icon scene and add it as a child of the HBOX Container
	var _item_display = item_display.instance()
	_owner.add_child(_item_display)
	
	# Give the item display a reference to this script
	_item_display.storage = self
	
	# Set up icon using given name, description and icon
	_item_display.set_up_display(item, index)
	
		# If it is the first icon added to the array, then set it to focus
	if index == 0 and not swapped and _owner.name != "ItemsContainer":
		print("Happening")
		_item_display.set_focused()
		focused_item_changed(item.name, item.description)
		
	_item_display.connect("focused", self, "focused_item_changed")
	_item_display.connect("begin_swap", self, "swap")
	_item_display.connect("end_swap", self, "swap")

func focused_item_changed(_name, _desc):
	$VBoxContainer/HBoxContainer/CurrentSelection/ItemName.text = _name
	$VBoxContainer/HBoxContainer/CurrentSelection/ItemDescription.text = _desc

func swap(item, index, _owner):
	if not swapping:
		temp_swap = item
		temp_index = index
		temp_owner = _owner
	else:
		swapped = true
		
		# If the items are within the same type of inventory 
		if _owner == temp_owner:
			match _owner.name:
				# Storage
				"ItemsContainer":
					storage.swap_items(temp_index, index)
				# Player Inventory
				"InventoryContainer":
					inventory.swap_items(temp_index, index)	
		else:
			match temp_owner.name:
				# Storage
				"ItemsContainer":
					storage.set_item(temp_index, item)
				# Player Inventory
				"InventoryContainer":
					inventory.set_item(temp_index, item)
			match _owner.name:
				# Storage
				"ItemsContainer":
					storage.set_item(index, temp_swap)
				# Player Inventory
				"InventoryContainer":
					inventory.set_item(index, temp_swap)
		
		# Set the first selected item to the second

				
		# Set the second selected item to the first
	
		display_storage()
		display_inventory()
		$Timer.start()

	swapping = !swapping


func _on_Timer_timeout():
	$VBoxContainer/HBoxContainer/StorageContainer/ItemsContainer.get_child(temp_index).set_focused()


func _on_StorageMenu_mouse_entered():
	pass # Replace with function body.
