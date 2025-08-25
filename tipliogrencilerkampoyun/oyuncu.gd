extends CharacterBody2D

const JUMP_VELOCITY := -800.0
const DOUBLE_TAP_BOOST := 1.3

var double_jump := true

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Desktop fallback (space/enter)
	if Input.is_action_just_pressed("ui_accept"):
		_do_jump(false)

	# Variable jump height if key released early
	if Input.is_action_just_released("ui_accept") and velocity.y < 0.0:
		velocity.y = -1.0

	if is_on_floor():
		double_jump = true

	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		# Single tap = normal jump, double‑tap = stronger jump
		_do_jump(event.double_tap)

func _do_jump(power_jump: bool) -> void:
	var power := DOUBLE_TAP_BOOST if power_jump else 1.0
	if is_on_floor():
		velocity.y = JUMP_VELOCITY * power
	elif double_jump:
		velocity.y = JUMP_VELOCITY * power
		double_jump = false
