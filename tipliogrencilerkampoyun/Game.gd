extends Node

# Game.gd (only the relevant bits)
var skor: int = 0
var oyun_bitti := false

var hiz_carpani: float = 1.0  # legacy multiplier for any old scripts
var meter_multiplier: float = 1.0 

func _ready() -> void:
	# …your existing code…
	GameSpeed.update_from_meters(skor)
	GameSpeed.speed_changed.connect(func ():
		hiz_carpani = GameSpeed.get_speed("road") / GameSpeed.base_speed
	)
	hiz_carpani = GameSpeed.get_speed("road") / GameSpeed.base_speed

func add_meter() -> void:
	if oyun_bitti: return
	meter_multiplier += 0.005   # tune this value
	
	# meters now grow faster as multiplier increases
	skor += int(1 * meter_multiplier)
	
	GameSpeed.update_from_meters(skor)

func reset():
	hiz_carpani = 1.0
	skor = 0
	oyun_bitti = false

func game_over():
	if oyun_bitti:
		return
	oyun_bitti = true
	var overlay := preload("res://ui/GameOverOverlay.tscn").instantiate()
	get_tree().root.add_child(overlay)
	overlay.goster(skor)  # overlay handles the fade, then freezes time
