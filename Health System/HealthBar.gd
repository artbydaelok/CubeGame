extends ProgressBar

export (Texture) var texture

func _ready():
	$Icon.texture = texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
