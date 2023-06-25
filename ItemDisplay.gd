extends Button

export var focus = false

var item_name
var item_description
var storage_index

var item

# This is set in the storage script
var storage 

signal focused(label, description)
signal begin_swap()
signal end_swap()


# Called when the node enters the scene tree for the first time.
func _ready():
	if focus:
		set_focused()

func set_up_display(item_ref, index):
	item = item_ref
	item_name = item.name
	item_description = item.description
	storage_index = index
	icon = item.texture

func set_focused():
	grab_focus()

func _on_ItemDisplay_focus_entered():
	emit_signal("focused", item_name, item_description)


func _on_ItemDisplay_pressed():
	var _owner = get_parent()
	
	if not storage.swapping:
		emit_signal("begin_swap", item, storage_index, _owner)
	else:
		emit_signal("end_swap", item, storage_index, _owner)


func _on_ItemDisplay_mouse_entered():
	set_focused()
