extends Node

onready	var boss = find_node("Boss")
onready var player = find_node("CubeKB")

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var player_health = $LevelLayer/Level/CubeKB/Health
	var player_healthbar = $Interface/PlayerHealthBar
	var boss_health = $LevelLayer/Level/Boss/Health
	var boss_healthbar = $Interface/BossHealthBar
	
	player_health.connect("depleted", self, "game_over")
	player_health.connect("changed", player_healthbar, "set_value")
	player_health.connect("max_changed", player_healthbar, "set_max")
	player_health._initialize()
	
	boss_health.connect("changed", boss_healthbar, "set_value")
	boss_health.connect("max_changed", boss_healthbar, "set_max")
	boss_health.connect("depleted", self, "player_win")
	boss_health._initialize()
	
	player.boss = boss


func player_win():
	pass

func game_over():
	get_tree().change_scene("res://GameOver.tscn")
