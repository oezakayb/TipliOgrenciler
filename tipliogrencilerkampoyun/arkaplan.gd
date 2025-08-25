extends Sprite2D
@export var is_vfx := false
@export var speed_layer: String = "city"  # pick: "sky","city","wall","road"
@export var hareket_hizi: float = 120.0
@export var twin: NodePath   # point this to the other tile in the same layer

var _tex_w: int
var _twin_ref: Sprite2D

func _ready() -> void:
	_tex_w = int(texture.get_width())
	if twin != NodePath():
		_twin_ref = get_node(twin) as Sprite2D
	# start on whole pixels
	position = position.round()

func _physics_process(delta: float) -> void:
	if is_vfx:
		var v := GameSpeed.get_speed(speed_layer)
		global_position.x = round(global_position.x - v * delta)
# compute world-left X at mid-screen height, camera-agnostic
		var vp_size: Vector2 = get_viewport().get_visible_rect().size
		var screen_mid_left := Vector2(0.0, vp_size.y * 0.5)

		var world_left_x: float
		var cam := false #get_viewport().get_camera_2d()
		if cam:
			return
			# with Camera2D
			#world_left_x = cam.screen_to_world(screen_mid_left).x
		else:
			# no camera — convert screen->world via canvas transform
			var inv_canvas: Transform2D = get_viewport().get_canvas_transform().affine_inverse()
			world_left_x = (inv_canvas * screen_mid_left).x

		if global_position.x < world_left_x - 1000.0:
			queue_free()

		return
	var v := GameSpeed.get_speed(speed_layer)
	position.x = round(position.x - v * delta)

	# effective width in local space (accounts for sprite scale)
	var eff_w := int(round(_tex_w * abs(scale.x)))

	# 1‑px overlap to hide any rounding gap
	var overlap := 20

	if _twin_ref:
		# handle big steps at high speed
		while position.x <= -eff_w:
			var rightmost := float(max(position.x, _twin_ref.position.x))
			position.x = floor(rightmost + eff_w - overlap)
	else:
		while position.x <= -eff_w:
			position.x += 2 * eff_w
			# maintain the same overlap logic on the fallback too
			position.x -= overlap
