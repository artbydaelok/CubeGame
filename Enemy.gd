extends KinematicBody

var path = []
var path_node = 0

var speed = 5

onready var health = $Health

enum STATES {DEFAULT, IDLE, CHASING, PATROLLING, STUNNED, ATTACKING, DEFENDING}

export (STATES) var current_state = STATES.DEFAULT

# Distance to Player
var distance_to_player
# Distance for enemy to stop attacking player 
# after they leave attacking distance
export var distance_to_stop_attack = 10

signal on_death

onready var nav = get_parent()
onready var player = get_node("../../CubeKB")

func _ready():
	
	connect("on_death", player, "update_target")
	
	match current_state:
		STATES.CHASING:
			$ChaseTimer.start()
		STATES.PATROLLING:
			# Select random navigable points, and go to these locations.
			pass
		STATES.STUNNED:
			# Start the stun timer, and remove any behaviour for the duration of the timer.
			# Activate animation if there is one
			pass
		STATES.ATTACKING:
			pass
		
		
	$Health.connect("depleted", self, "defeated")
	
	
func _process(delta):
	# Store a variable every frame calculating distance to player.
	# This variable will be used to determine whether player is within attacking distance
	distance_to_player = self.translation.distance_to(player.translation)
	
func _physics_process(delta):
	if path_node < path.size():
		var direction = (path[path_node]- global_transform.origin)
		if direction.length() < 1: 
			path_node += 1
		else:
			move_and_slide(direction.normalized() * speed, Vector3.UP)
			
func move_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_node = 0

func take_damage(damage):
	print("Taking " + str(damage) + " damage")
	health.set_current(health.current - damage)

func attack():
	pass

func defeated():
	player.target = null
	emit_signal("on_death")
	queue_free()


func _on_ChaseTimer_timeout():
	move_to(player.global_transform.origin)
