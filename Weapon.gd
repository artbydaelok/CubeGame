extends Spatial

var player
var look_at_boss = true

func _ready():
	player = find_parent("CubeKB")

func _process(_delta):
	if look_at_boss:
		look_at(player.boss.translation, Vector3.UP)
