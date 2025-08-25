extends Node
signal speed_changed

# --- Designer knobs ---
@export var base_speed: float = 260.0        # px/sec at difficulty = 1.0
@export var use_sqrt_curve := true           # meters -> difficulty curve toggle
@export var linear_gain_per_m := 0.004       # used if use_sqrt_curve = false
@export var sqrt_gain := 0.16                # used if use_sqrt_curve = true
@export var min_difficulty := 1.0
@export var max_difficulty := 8.0            # safety cap; raise if you want

# Per-layer multipliers (edit at runtime if you like)
var layer_mul := {
	"sky": 1.00,
	"city": 1.00,
	"wall": 1.00,
	"road": 1.00,
	"obstacle": 1.00,
	"fx": 1.00,
	"polisarabasi": 2.0,
	"poliskosma": 1.5
}

# --- Backing store for property ---
var _difficulty: float = 1.0

# --- Property (Godot 4 style) ---
var difficulty: float:
	get:
		return _difficulty
	set(value):
		_difficulty = clamp(value, min_difficulty, max_difficulty)
		emit_signal("speed_changed")

# --- Public API ---
func get_speed(layer: String = "road") -> float:
	# Global speed getter used by everything that moves.
	return base_speed * difficulty * (layer_mul.get(layer, 1.0))

func update_from_meters(meters: int) -> void:
	if use_sqrt_curve:
		difficulty = 1.0 + sqrt_gain * sqrt(max(meters, 0))
	else:
		difficulty = 1.0 + linear_gain_per_m * max(meters, 0)

func set_layer_multiplier(layer: String, mul: float) -> void:
	layer_mul[layer] = max(mul, 0.0)
	emit_signal("speed_changed")
