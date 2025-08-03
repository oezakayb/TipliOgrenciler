extends Area2D

@export var hareket_hizi : float = 8.0
# const oyun_bitti = preload("res://")

var sprite : Sprite2D

func _physics_process(delta: float) -> void:
	if sprite and global_position.x <= -sprite.texture.get_width():
		queue_free()
	global_position.x -= hareket_hizi

func carpinca(body : Node2D) -> void:
	if(body.name == "Oyuncu"):
		get_tree().paused = true
		
