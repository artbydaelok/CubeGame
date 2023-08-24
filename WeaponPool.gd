extends Resource

var shotgun = preload("res://Items/Shotgun/shotgun.tres")
var molotov = preload("res://Items/molotov.tres")
var boomerang = preload("res://Items/Boomerang/boomerang.tres")
var spear = preload("res://Items/Spear/spear.tres")
var pepper_spray = preload("res://Items/pepper_spray.tres")


var weapon_pool = [
	shotgun, 
	molotov,
	boomerang,
	spear,
	pepper_spray
]

var unlocked_weapons = []
