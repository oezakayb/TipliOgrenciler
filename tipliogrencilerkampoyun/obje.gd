extends Timer

@export var spacing_px: float = 700.0          # distance between VFX
@export var speed_layer: String = "wall"       # parallax bucket they follow
@export var offscreen_margin_px: float = 300.0  # how far beyond screen-right
@export var lane_y: Array[float] = [32.0, 48.0, 64.0]

@export var arkaplan_nesneleri: Array[Texture2D] = []
@onready var arkaplan_nesnesi := preload("res://arkaplan_nesnesi.tscn")

var önceki_arkaplan_nesnesi = null

func _ready() -> void:
	timeout.connect(_spawn_one)
	GameSpeed.speed_changed.connect(_update_wait)
	_update_wait()
	start()

func _update_wait() -> void:
	# time = distance / speed → consistent spacing as speed changes
	var v := GameSpeed.get_speed(speed_layer)
	wait_time = clamp(spacing_px / max(v, 1.0), 0.10, 5.0)

func _spawn_one() -> void:
	if arkaplan_nesnesi == null:
		start(); return

	var inst := arkaplan_nesnesi.instantiate()

	# set a random texture on the Sprite2D in the scene
	if arkaplan_nesneleri.size() > 0:
		var tex = arkaplan_nesneleri.pick_random()
		while önceki_arkaplan_nesnesi == tex:
			tex = arkaplan_nesneleri.pick_random()
		önceki_arkaplan_nesnesi = tex
		if inst is Sprite2D:
			inst.texture = tex
		elif inst.has_node("Sprite2D"):
			inst.get_node("Sprite2D").texture = tex

	# tell arkaplan.gd this is a VFX mover (not a tiling background)
	inst.is_vfx = true
	inst.speed_layer = speed_layer

	# ---- screen → world without Camera2D ----
	var vp := get_viewport()
	var screen_size := vp.get_visible_rect().size
	var screen_right := Vector2(screen_size.x, screen_size.y * 0.5)
	# canvas_transform maps WORLD→SCREEN, so invert it for SCREEN→WORLD:
	# Option A (cleanest)
	var world_right: Vector2 = vp.get_canvas_transform().affine_inverse() * screen_right


	var spawn_x := world_right.x + offscreen_margin_px
	var y = 0.0 if lane_y.is_empty() else lane_y.pick_random()

	# place in world space, then add under the same parent as this timer
	if inst is Node2D:
		inst.global_position = Vector2(round(spawn_x), round(y))
	else:
		inst.position = Vector2(round(spawn_x), round(y))  # fallback

	get_parent().add_child(inst)
	start()  # restart with current wait_time
