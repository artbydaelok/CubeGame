extends "res://Projectile.gd"

const splash = preload("res://Items/WaterBalloon/Splash.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	look_at(player.boss.translation, Vector3.UP)

func splash():
	var _s = splash.instance()
	_s.translation = self.translation + 2*Vector3.UP
	get_parent().add_child(_s)
	print(_s)
	
func _on_Area_body_entered(body):
	if body.is_in_group("Enemy"):
		splash()
		queue_free()



func _on_Arc_tween_all_completed():
	splash()
	queue_free()
