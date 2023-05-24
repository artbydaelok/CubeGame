extends Spatial

export var rotation_speed = PI/2
export var max_zoom = 3.0
export var min_zoom = 0.5
export var zoom_speed = 0.09

export (NodePath) var target

var r_joy_active = false

var mouse_control = true
var mouse_sensitivity = 0.005

var cam_speed = 5

var zoom = 1.5
export (bool) var invert_y = false
export (bool) var invert_x = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	if target:
		global_transform.origin = get_node(target).global_transform.origin
	if !mouse_control:
		get_input_keyboard(delta)
	
	# If the right joystick is being used
	if r_joy_active:
		rotate_object_local(Vector3.UP, -1 * (Input.get_action_strength("move_camera_right") - Input.get_action_strength("move_camera_left")) * delta * cam_speed)
		$InnerGimbal.rotate_object_local(Vector3.RIGHT, (Input.get_action_strength("move_camera_up") - Input.get_action_strength("move_camera_down")) * delta * cam_speed)
	$InnerGimbal.rotation.x = clamp($InnerGimbal.rotation.x, -1.4, 0.1)
	scale = lerp(scale, Vector3.ONE * zoom, zoom_speed)
	
func _input(event):
	r_joy_active = abs(Input.get_action_strength("move_camera_right") - Input.get_action_strength("move_camera_left")) >  0.1 or abs(Input.get_action_strength("move_camera_up") - Input.get_action_strength("move_camera_down")) > 0.1
	if event is InputEventJoypadMotion:
		# CODE FOR GAMEPAD
		pass
	elif r_joy_active == false and event is InputEventMouseMotion:
		if event.relative.x != 0:
			var dir = 1 if invert_x else -1
			rotate_object_local(Vector3.UP, dir * event.relative.x * mouse_sensitivity)
		if event.relative.y != 0:
			var dir = 1 if invert_y else -1
			$InnerGimbal.rotate_object_local(Vector3.RIGHT, dir * event.relative.y * mouse_sensitivity)
	if event.is_action_pressed("zoom_in"):
		zoom -= zoom_speed
	if event.is_action_pressed("zoom_out"):
		zoom += zoom_speed
	zoom = clamp(zoom, min_zoom, max_zoom)
	

func get_input_keyboard(delta):
	# Rotate outer gimbal around y axis
	var y_rotation = 0
	if Input.is_action_pressed("ui_left"):
		y_rotation += 1
	if Input.is_action_pressed("ui_right"):
		y_rotation -= 1
	rotate_object_local(Vector3.UP, y_rotation * rotation_speed * delta)
	
	# Rotate inner gimbal around x axis
	var x_rotation = 0
	if Input.is_action_pressed("ui_up"):
		x_rotation += 1
	if Input.is_action_pressed("ui_down"):
		x_rotation -= 1
	$InnerGimbal.rotate_object_local(Vector3.RIGHT, x_rotation * rotation_speed * delta)
	
