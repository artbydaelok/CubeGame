extends KinematicBody

#class_name Boss

export var angle = 1
export var distance = 20
onready var health = $Health

var center = Vector3.ZERO
onready var t = $Tween

var voffset = 5

onready var relocate_timer = $RelocateTimer

var rng = RandomNumberGenerator.new()
onready var firewall = preload("res://Hazards/FireWallSpawner.tscn")

var level

func _ready():
	# This gets the level node 
	level = get_parent()
	rng.randomize()
	rotate_to(rng.randi_range(-4, 4) * 90, distance, 2)

func _process(delta):
	# Set position/translation
	# These values get updated in other functions
	var target_pos = center + Vector3(cos(angle), 0, sin(angle)) * distance + Vector3.UP * voffset
	self.global_translation = target_pos
	look_at(Vector3.ZERO, Vector3.UP)
	
	
func take_damage(damage):
	print("Taking " + str(damage) + " damage")
	health.set_current(health.current - damage)
	
func rotate_to(new_angle, new_distance, speed):
	t.interpolate_property(self, "angle", angle, deg2rad(new_angle), speed, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	t.interpolate_property(self, "distance", distance, new_distance, speed, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	t.start()
	
func constant_rotation(delta_angle):
	# Constant Rotation
	# This will probably not be used by this boss, but it could fit a dragon-type of boss. 
	self.global_translation = center + (self.global_translation - center).rotated(Vector3.UP, delta_angle)

func spawn_firewall():
	var _fw = firewall.instance()
	level.add_child(_fw)
	_fw.global_translation = Vector3(self.global_translation.x, 0, self.global_translation.z)
	_fw.look_at(Vector3.ZERO, Vector3.UP)
	

func _on_RelocateTimer_timeout():
	# We should check for the current boss state.
	
	
	# Rotates the boss to a random location from -360 to 360 degrees. 
	rotate_to(rng.randi_range(-4, 4) * 90, distance, 2)



func _on_Tween_tween_all_completed():
	print("Spawning firewall")
	
	# Sets a new wait time for the timer
	relocate_timer.wait_time = rng.randi_range(3, 10)
	relocate_timer.start()
	
	spawn_firewall() 
