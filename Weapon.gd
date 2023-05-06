extends Spatial

var player
var look_at_boss = true

var active = false

func _ready():
	player = find_parent("CubeKB")

func _process(_delta):
	if look_at_boss:
		aim_at_boss()
		
func set_active(new_active):
	active = new_active
	
func aim_at_boss():
	look_at(player.boss.translation, Vector3.UP)
