extends RigidBody

var velocity

export (int) var speed
export (int) var damage
export (Texture) var texture

export (float) var self_destroy_time

onready var destroy_timer = $SelfDestroyTimer
onready var arc = $Arc

var time_elapsed = 0
var total_time = 3

## Lob and Shoot Variables
var current_pos
var current_y
var start_pos
var end_pos
var midpoint_pos
var is_lobbed = false

var last_position
var last_direction
#

var homing_target

var player

enum PROJECTILE_STATE {DEFAULT, SHOT, LOB,THROWN, HOMING}

var state = PROJECTILE_STATE.DEFAULT

func _ready():
	randomize()
	$SelfDestroyTimer.start()
	
	look_at(player.boss.translation, Vector3.UP)
	set_as_toplevel(true)
	
	#arc.connect("tween_completed", self, "_on_tween_completed")
	
func _process(delta):
	match state:
		PROJECTILE_STATE.DEFAULT:
			pass
		PROJECTILE_STATE.SHOT:
			pass
		PROJECTILE_STATE.LOB:
			if last_position:
				last_direction = last_position.direction_to(translation)
			last_position = translation
			translation = Vector3(current_pos.x, current_y, current_pos.z)
		PROJECTILE_STATE.HOMING:
			home_to_target(homing_target, 2500 * delta)
		PROJECTILE_STATE.THROWN:
			pass
		
		
func shoot_at(target_position, spread):
	# Checks if this specific projectile is currently being used.
	if state == PROJECTILE_STATE.DEFAULT:
		# Setting the state to shot
		state = PROJECTILE_STATE.SHOT
		# Applying the shooting impulse for the projectile from its location towards the target_location
		apply_central_impulse(self.translation.direction_to(target_position) * speed + Vector3(rand_range(-spread, spread), rand_range(-spread, spread), rand_range(-spread, spread)))
		
func lob_at(target, height, duration):
	# Set the velocity to zero
	linear_velocity = Vector3.ZERO
	# Set the state to LOB
	state = PROJECTILE_STATE.LOB
	start_pos = self.translation
	end_pos = target.translation + Vector3.UP * 2
	midpoint_pos = (start_pos + end_pos) / 2
	midpoint_pos.y += height
######################################
	arc.interpolate_property(self, "current_pos", start_pos, end_pos, duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	arc.interpolate_property(self, "current_y", start_pos.y, midpoint_pos.y, duration * 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	arc.interpolate_property(self, "current_y", midpoint_pos.y, end_pos.y, duration * 0.5, Tween.TRANS_QUAD, Tween.EASE_IN, duration * 0.5)
	arc.start()
	
func return_to_player():
	pass

func home_to_target(target, strength):
	add_central_force(self.translation.direction_to(target.translation + Vector3.UP * 2) * strength)

func _on_Area_body_entered(body):
	if body.is_in_group("Enemy"):
		body.take_damage(damage)


func _on_SelfDestroyTimer_timeout():
	#print("Destroying Projectile")
	queue_free()
