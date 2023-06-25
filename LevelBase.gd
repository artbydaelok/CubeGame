extends Spatial


# Called when the node enters the scene tree for the first time.
func _ready():
	for station in $ShuffleStations.get_children():
		station.connect("inventory_shuffling", $InventoryShuffle, "toggle")

