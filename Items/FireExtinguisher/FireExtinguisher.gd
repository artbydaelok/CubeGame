extends "res://Weapon.gd"

onready var particles = $ExtMesh/ParticleStart/ExtinguishingParticles
var rotate = false

func spin():
	look_at_boss = false
	rotate = true
	$Timer.start()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_active(new_active):
	particles.active = new_active

func _process(delta):
	if rotate:
		$ExtMesh.rotate_y(12*delta)

func _on_Timer_timeout():
	rotate = false
	look_at_boss = true
	$ExtMesh.rotation = Vector3(0, PI/2, 0)
