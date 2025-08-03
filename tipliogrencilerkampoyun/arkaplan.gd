extends Sprite2D

@export var hareket_hizi : float = 5.0
@export var tekrarlar : bool = true

func _physics_process(delta: float) -> void:
	if(position.x <= -texture.get_width()):
		if tekrarlar:
			position.x = texture.get_width() - 1
		else:
			queue_free()
	position.x -= hareket_hizi
