extends CharacterBody2D

const JUMP_VELOCITY = -800.0

var double_jump = true


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("ui_accept") and not is_on_floor() and double_jump:
		velocity.y = JUMP_VELOCITY
		double_jump = false
	if Input.is_action_just_released("ui_accept") and velocity.y < 0:
		velocity.y = -1
	if is_on_floor():
		double_jump = true
	move_and_slide()
