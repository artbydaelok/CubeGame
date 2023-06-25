extends Spatial

var player
var look_at_target = true

var active = false

func _ready():
	player = find_parent("CubeKB")
	player.connect("roll", self, "on_player_roll")

func _process(_delta):
	if look_at_target:
		aim_at_target()
		
func set_active(new_active):
	active = new_active
	
func aim_at_target():
	if player.target:
		look_at(player.target.translation, Vector3.UP)
		
func on_player_roll():
	pass
