extends Sprite3D

var inventory 
var camera

# Called when the node enters the scene tree for the first time.
func _ready():
	inventory = $"../..".inventory
	camera = $"../../CameraGimbal".get_node("InnerGimbal").get_node("Camera")

func _process(delta):
	if camera:
		look_at(camera.global_translation, Vector3.UP)

