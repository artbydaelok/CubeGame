extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	var player_health = $LevelLayer/Level/CubeKB/Health
	var healthbar = $Interface/Interface/HealthBar
	
	player_health.connect("changed", healthbar, "set_value")
	player_health.connect("max_changed", healthbar, "set_max")
	player_health._initialize()
