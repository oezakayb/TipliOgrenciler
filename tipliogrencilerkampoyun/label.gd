extends Control

@onready var direnis_label = $Metre/DirenisLabel
@onready var metre_timer = $Metre

func _ready():
	metre_timer.timeout.connect(_on_DistanceTimer_timeout)
	_update_label()

func _on_DistanceTimer_timeout():
	Game.add_meter()
	_update_label()

func _update_label():
	direnis_label.text = "DİRENİŞ: %dm" % Game.skor
