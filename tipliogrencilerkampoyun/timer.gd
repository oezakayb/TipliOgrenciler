extends Timer

func _ready() -> void:
	timeout.connect(_tick)
	start()

func _tick() -> void:
	# however you were counting distance before:
	Game.add_meter()
