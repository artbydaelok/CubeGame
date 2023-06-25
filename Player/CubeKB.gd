extends KinematicBody
class_name Player

signal item_used(index, cooldown_duration)

signal roll

var inventory = preload("res://Inventory.tres")
#onready var game = get_node("../../..")

const spear = preload("res://Items/Spear/Spear.tscn")
const bullet = preload("res://Items/Bullet.tscn")
const tennis_ball = preload("res://Items/Tennis/TennisBall.tscn")
const boomerang = preload("res://Items/Boomerang/Boomerang.tscn")
const water_balloon = preload("res://Items/WaterBalloon/WaterBalloon.tscn")

onready var shotgun = $Weapons/Shotgun
onready var tennis_racket = $Weapons/TennisRacket
onready var fire_ext = $Weapons/FireExtinguisher

onready var weapons

var boss

var possible_targets = []
var target

signal shoot

var actve_item

export var speed = 6.0

onready var pivot = $Pivot
onready var mesh = $Pivot/MeshInstance
onready var tween = $Tween

onready var side_one = $Pivot/MeshInstance/DiceSides/SideOne
onready var side_two = $Pivot/MeshInstance/DiceSides/SideTwo
onready var side_three = $Pivot/MeshInstance/DiceSides/SideThree
onready var side_four = $Pivot/MeshInstance/DiceSides/SideFour
onready var side_five = $Pivot/MeshInstance/DiceSides/SideFive
onready var side_six = $Pivot/MeshInstance/DiceSides/SideSix

const numbers_material = preload("res://Player/PlayerNumberFacesMaterial.tres")

export var using_numbers = false

##
## At the moment, we are calculating which side is up by comparing its Y value to 2
## This is the Y value for any side that is currently facing up, but this method will
## not work if the dice is shifted in the Y axis for whatever, reason.
## Another way to implement it with the same logic would be to store a temporary
## variable that represents the side which has the highest Y value, and if another 
## side has a higher Y value, then set the variable to this side. There will only be
## One side that is higher than the others, and this side is the one facing up. 
##

enum SIDES_STATE {ONE, TWO, THREE, FOUR, FIVE, SIX}
var up_side = SIDES_STATE.TWO


export (NodePath) var camera_path
onready var camera = get_node(camera_path)
onready var sides = [side_one, side_two, side_three, side_four, side_five, side_six]

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	inventory.connect("active_changed", self, "set_active_weapon")
	if boss:
		target = boss
	if using_numbers:
		$Pivot/MeshInstance.set_surface_material(0, numbers_material)
	
	weapons = $Weapons.get_children()
	detect_side_up()
	
func _physics_process(_delta):
	# Print Distance from boss to test weapons
	#print(distance_from_boss())
	
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
		var _item
		match up_side:
			SIDES_STATE.ONE:
				_item = inventory.get_item(0)
			SIDES_STATE.TWO:
				_item = inventory.get_item(1)
			SIDES_STATE.THREE:
				_item = inventory.get_item(2)
			SIDES_STATE.FOUR:
				_item = inventory.get_item(3)
			SIDES_STATE.FIVE:
				_item = inventory.get_item(4)
			SIDES_STATE.SIX:
				_item = inventory.get_item(5)
		if inventory.get_active_item():
			use_item(_item)

func clear_weapon_mesh():
	for weapon in weapons:
		weapon.visible = false
		weapon.set_active(false)

func set_active_weapon(index):
	clear_weapon_mesh()
	if inventory.get_active_item():
		match inventory.get_active_item().name:
			#### REMEMBER NOT ALL WEAPONS HAVE TO USE THE COOLDOWN VARIABLE ####
			"Shotgun":
				shotgun.visible = true
			"Molotov":
				pass
			"Spear":
				pass
			"Pepper Spray":
				pass
			"Boomerang":
				pass
			"Tennis":
				tennis_racket.visible = true
			"Fire Extinguisher":
				fire_ext.visible = true
				fire_ext.set_active(true)
		
func detect_side_up():
	for s in sides:
		#print(s.name + " " + str(sides[0].global_translation))
		var s_pos = s.global_translation
		if s_pos.y == 2:
			match s:
				side_one:
					up_side = SIDES_STATE.ONE
					inventory.set_active_item(0)
				side_two:
					up_side = SIDES_STATE.TWO
					inventory.set_active_item(1)
				side_three:
					up_side = SIDES_STATE.THREE
					inventory.set_active_item(2)
				side_four:
					up_side = SIDES_STATE.FOUR
					inventory.set_active_item(3)
				side_five:
					up_side = SIDES_STATE.FIVE
					inventory.set_active_item(4)
				side_six:
					up_side = SIDES_STATE.SIX
					inventory.set_active_item(5)
	
func distance_from_target():
	return self.translation.distance_to(target.translation)
		
func use_item(item):
	#print(distance_from_boss())
	# If the item we are trying to use isn't on cooldown
	if item.on_cooldown == false:
		# Set the cooldown to true
		item.on_cooldown = true
		# And choose the behavior according to the item
		match item.name:
		#### REMEMBER NOT ALL WEAPONS HAVE TO USE THE COOLDOWN VARIABLE ####
			"Shotgun":
				if target:
					for b in range (6):
						var _b = bullet.instance()
						_b.player = self
						_b.translation = shotgun.find_node("MuzzleFlashStart").global_translation
						get_parent().add_child(_b)
						_b.shoot_at(target.translation, 12)
				
			"Molotov":
				pass
			"Spear":
				if target:
					var _spear = spear.instance()
					# Spawns the spear projectile
					_spear.translation = self.translation + 2 * Vector3.UP
					_spear.player = self
					get_parent().add_child(_spear)
					
					_spear.shoot_at(target.translation, 0)
				# Include a tween for long range that moves a collider towards the boss current location, 
				# this can be an instanced object that damages the boss when it touches them. 
			"Pepper Spray":
				# Set a timer that runs down the spray amount, when it reaches 0, reload
				if distance_from_target() < 14:
					target.take_damage(4)
				# Set a short timer that applies this damage until it runs out 
			"Boomerang":
				# Throw the boomerang in an arc, it then comes back to the player after it hits the boss
				var _b = boomerang.instance()
				_b.translation = self.translation + 2 * Vector3.UP
				_b.player = self
				get_parent().add_child(_b)
				_b.throw_boomerang(boss)
			"Tennis":
				# Spawn tennis ball projectile
				var _tb = tennis_ball.instance()
				_tb.translation = self.translation + 2*Vector3.UP
				_tb.player = self
				get_parent().add_child(_tb)
				
				# Shoot it at the boss.
				_tb.shoot_at(boss.translation, 0)
			
				# The ball bounces off the boss and falls on a random tile
				# which gets a tennis ball icon hovering above it to let 
				# the player know the ball will fall there
			"Fire Extinguisher":
				# Puts out any fire walls or fire tiles within one tile of the player. 
				fire_ext.spin()
			"Water Balloon":
				# Weakens enemy attacks and bosses. Puts out fire tiles if it lands on one. 
				var _wb = water_balloon.instance()
				_wb.translation = self.translation + 2*Vector3.UP
				_wb.player = self
				get_parent().add_child(_wb)
				
				_wb.lob_at(boss, 5, 1)
			"Tiny Rocket":
				# Spawns a toy rocket that shoots upwards and damages anything above the player
				pass
			"Ray Gun":
				# Shoot a beam laser that the longer you hold, the more damage it does
				pass
			"Shooting Star":
				# Summons a star above you with a gun that shoots the enemies
				pass
		inventory.use_item()
		# Set the cooldown timer here
		# We could tie this cooldown number to a radial progress bar and a tween that completes it
		yield(get_tree().create_timer(item.cooldown), "timeout")
		item.on_cooldown = false


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
	
	
	# Emit signal when roll begins
	emit_signal("roll")
	
	# Reset Shotgun Cooldown when rolling
	if inventory.get_active_item():
		if inventory.get_active_item().name == "Shotgun":
			inventory.reset_item_cooldown(inventory.get_active_item_index())
	
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


func _on_EnemyDetectionRadius_body_entered(body):
	if body.is_in_group("enemy"):
		if possible_targets.size() == 0:
			target = body
			print("Adding Target")
		possible_targets.append(body)
		print(target)
