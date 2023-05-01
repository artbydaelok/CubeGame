extends CenterContainer

# Preload the inventory data
var inventory = preload("res://Inventory.tres")
var non_active_bg = preload("res://Inventory/Item Border.png")
var active_bg = preload("res://Inventory/Item Border Highlighted.png")
onready var background = $SlotBG

var cooldown_time = 0

onready var tween = $Tween
onready var cd_prog = $SlotBG/CooldownProgBar
onready var itemTextureRect = $TextureRect

var is_active = false

func _ready():
	inventory.connect("item_used", self, "start_cooldown")
	inventory.connect("cooldown_reset", self, "cooldown_reset")

func display_item(item):
	# This displays an item if it finds one, otherwise a null image
	if item is Item:
		itemTextureRect.texture = item.texture
	else:
		itemTextureRect.texture = load("res://Items/3dCrosshair.png")

func set_active(new_active):
	is_active = new_active
	if is_active:
		background.texture = active_bg
	else:
		background.texture = non_active_bg

func get_drag_data(_position):
	var item_index = get_index()
	var item = inventory.remove_item(item_index)
	if item is Item:
		var data = {}
		data.item = item
		data.item_index = item_index
		var dragPreview = TextureRect.new()
		dragPreview.texture = item.texture
		set_drag_preview(dragPreview)
		inventory.drag_data = data
		return data

func cooldown_reset():
	if is_active:
		cooldown_time = 0
		cd_prog.value = cooldown_time
		tween.stop_all()
		itemTextureRect.set_modulate(Color(1, 1, 1, 1))

func start_cooldown(dur):
	if is_active:
		tween.interpolate_property(self, "cooldown_time", 0, 100, dur, tween.TRANS_LINEAR, tween.TRANS_LINEAR)
		tween.start()
		itemTextureRect.set_modulate(Color(1, 1, 1, 0.4))
		
func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")
	
func drop_data(_position, data):
	var my_item_index = get_index()
	var my_item = inventory.items[my_item_index]
	
	inventory.swap_items(my_item_index, data.item_index)
	inventory.set_item(my_item_index, data.item)
	inventory.drag_data = null


func _on_Tween_tween_all_completed():
	# And then resets the value in this script and in the cd_prog widget
	cooldown_time = 0
	cd_prog.value = cooldown_time
	itemTextureRect.set_modulate(Color(1, 1, 1, 1))


func _on_Tween_tween_step(object, key, elapsed, value):
	# Sets the value in the progress bar throughout the cooldown
	cd_prog.value = cooldown_time
