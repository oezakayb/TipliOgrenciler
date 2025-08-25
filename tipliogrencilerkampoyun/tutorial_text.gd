extends Label

@export var temel_hiz := 5.0  # match your background's hareket_hizi for 1:1 parallax
@export var yasam_suresi := 15.0  # seconds before auto-despawn

func _ready():
	
	await get_tree().create_timer(yasam_suresi).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	# Moves back with background speed scaled by global multiplier
	position.x -= temel_hiz * Game.hiz_carpani
	# Safety: if fully off-screen, remove
	if position.x < -5000:
		queue_free()
