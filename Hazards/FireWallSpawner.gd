extends Spatial

var spawn_pos_array = []
var fire_wall = preload("res://Hazards/FireWall.tscn")
onready var walls_node = $Walls

var rng = RandomNumberGenerator.new()
enum DIRECTIONS {FORWARD, BACK, LEFT, RIGHT}
export(DIRECTIONS) var direction

func _ready():
	rng.randomize()
	
	# Set the direction of the walls
	match direction:
		DIRECTIONS.FORWARD:
			direction = Vector3.FORWARD
		DIRECTIONS.BACK:
			direction = Vector3.BACK
		DIRECTIONS.LEFT:
			direction = Vector3.LEFT
		DIRECTIONS.RIGHT:
			direction = Vector3.RIGHT
			
	# Get a refence to the empty notes where spawn locations will be
	var spawn_nodes = $SpawnPoints.get_children()
	for n in spawn_nodes.size():
		spawn_pos_array.append(spawn_nodes[n].global_translation)
	spawn_wall()
	
func spawn_wall():
	for pos in spawn_pos_array:
		var _wall = fire_wall.instance()
		walls_node.add_child(_wall)
		_wall.direction = direction
		_wall.global_translation = pos
		
	
	var walls_children = walls_node.get_children()
	walls_children[rng.randi_range(0, walls_children.size() - 1)].queue_free()
	
