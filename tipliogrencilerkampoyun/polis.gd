extends Area2D

@export var speed_layer := "obstacle"
@export var hareket_hizi: float = 8.0
var sprite: Sprite2D

func _physics_process(delta: float) -> void:
	if sprite and global_position.x <= -sprite.texture.get_width():
		queue_free()
	global_position.x = round(global_position.x - GameSpeed.get_speed(speed_layer) * delta)

func carpinca(body: Node2D) -> void:
	if body.name == "Oyuncu":
		Game.game_over()
