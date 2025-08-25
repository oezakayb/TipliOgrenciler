extends CanvasLayer

@onready var fade: ColorRect = $ColorRect
@onready var panel: VBoxContainer = $VBoxContainer
@onready var score_label: Label = $VBoxContainer/ScoreLabel
@onready var replay: Button = $VBoxContainer/ReplayButton

func _ready() -> void:
	layer = 100                   # on top

	# Make sure the UI eats clicks, but the black fade doesn't.
	fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.mouse_filter = Control.MOUSE_FILTER_STOP

	# Draw order: panel above fade (both are siblings in the same CanvasLayer)
	fade.z_index = 0
	panel.z_index = 1

	# Start transparent
	var m := fade.modulate
	m.a = 0.0
	fade.modulate = m

	replay.pressed.connect(_replay)

func goster(skor: int) -> void:
	score_label.text = "SKOR: %dm" % skor
	var t := create_tween()
	t.tween_property(fade, "modulate:a", 1.0, 0.35)  # ← fully opaque black
	t.tween_callback(_freeze_world)

func _freeze_world() -> void:
	Engine.time_scale = 0.0   # freeze gameplay, UI still works

func _replay() -> void:
	# 1) stop double-click spam
	replay.disabled = true

	# 2) allow tween timing to progress
	Engine.time_scale = 1.0

	# 3) fade from opaque black -> transparent, then reload
	var t := create_tween()
	# (If you kept tree pause anywhere else, you can keep this line; harmless otherwise)
	t.set_pause_mode(1) # Tween.TWEEN_PAUSE_PROCESS
	t.tween_property(fade, "modulate:a", 0.0, 0.25)
	t.tween_callback(func ():
		Game.reset()
		get_tree().reload_current_scene()
		queue_free()
	)
