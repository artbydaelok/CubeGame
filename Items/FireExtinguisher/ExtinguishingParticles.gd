extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area_body_entered(body):
	pass


func _on_Area_area_entered(area):
	if area.is_in_group("Fire") and active:
		print("Fire extinguished")
		area.queue_free()
