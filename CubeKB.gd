extends KinematicBody
class_name Player


export var speed = 6.0

onready var pivot = $Pivot
onready var mesh = $Pivot/MeshInstance
onready var tween = $Tween

onready var side_one = $Pivot/DiceSides/SideOne
onready var side_two = $Pivot/DiceSides/SideTwo
onready var side_three = $Pivot/DiceSides/SideThree
onready var side_four = $Pivot/DiceSides/SideFour
onready var side_five = $Pivot/DiceSides/SideFive
onready var side_six = $Pivot/DiceSides/SideSix


enum SIDES_STATE {ONE, TWO, THREE, FOUR, FIVE, SIX}
var up_side = SIDES_STATE.TWO


export (NodePath) var camera_path
onready var camera = get_node(camera_path)
onready var sides = [side_one, side_two, side_three, side_four, side_five, side_six]

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(_delta):
	var forward = Vector3.FORWARD
	if camera:
		forward = Vector3.ZERO
		var cam_forward = -camera.transform.basis.z.normalized()
		var cam_axis = cam_forward.abs().max_axis()
		forward[cam_axis] = sign(cam_forward[cam_axis])
		
		# Movement
	if Input.is_action_pressed("up"):
		roll(forward)
	if Input.is_action_pressed("down"):
		roll(-forward)
	if Input.is_action_pressed("right"):
		roll(forward.cross(Vector3.UP))
	if Input.is_action_pressed("left"):
		roll(-forward.cross(Vector3.UP))
	
	# Use Items
	if Input.is_action_just_pressed("use_item"):
		pass
		
func detect_side_up():
	print("Player Pos: " + str(self.global_translation))
	for s in sides:
		#print(s.name + " " + str(sides[0].global_translation))
		var s_pos = s.global_translation
		if s_pos.y == 2:
			print(s_pos.y)
			match s:
				side_one:
					up_side = SIDES_STATE.ONE
				side_two:
					up_side = SIDES_STATE.TWO
				side_three:
					up_side = SIDES_STATE.THREE
				side_four:
					up_side = SIDES_STATE.FOUR
				side_five:
					up_side = SIDES_STATE.FIVE
				side_six:
					up_side = SIDES_STATE.SIX
			print (up_side)
		
# Movement
func roll(dir):
	# Do nothing if we're currently rolling.
	if tween.is_active():
		return
	
	# Cast a ray before moving to check for collisions/obstacles
	var space = get_world().direct_space_state
	var collision = space.intersect_ray(mesh.global_transform.origin, 
				mesh.global_transform.origin + dir * 2.5, [self])
	
	if collision:
		return
	
	## Step 1: Offset the pivot
	pivot.translate(dir)
	mesh.global_translate(-dir)

	## Step 2: Animate the rotation
	var axis = dir.cross(Vector3.DOWN)
	tween.interpolate_property(pivot, "transform:basis",
			null, pivot.transform.basis.rotated(axis, PI/2),
			1/speed, Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_all_completed")

	## Step 3: Finalize movement and reverse the offset
	transform.origin += dir * 2
	var b = mesh.global_transform.basis ## Save the rotation
	pivot.transform = Transform.IDENTITY
	mesh.transform.origin = Vector3(0, 1, 0)
	mesh.global_transform.basis = b
	
	detect_side_up()

func _on_Tween_tween_step(object, key, elapsed, value):
	pivot.transform = pivot.transform.orthonormalized()
