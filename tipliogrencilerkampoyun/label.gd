extends Control

var distance : int = 0

@onready var direnis_label = $Metre/DirenisLabel
@onready var metre_timer = $Metre

func _ready():
	metre_timer.timeout.connect(_on_DistanceTimer_timeout)
	update_label()

func _on_DistanceTimer_timeout():
	distance += 1
	update_label()

func update_label():
	direnis_label.text = "DIRENIS: " + str(distance) + "m "
