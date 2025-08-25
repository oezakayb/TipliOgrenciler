extends Sprite2D

@export var speed_layer := "obstacle"
@export var konteynerler: Array[Texture2D] = []
@onready var alan = $alan
const havai_fisek = preload("res://havai_fisek.tscn")
@export var move_speed := 8.0

func _ready() -> void:
	texture = konteynerler.pick_random()

func _physics_process(delta: float) -> void:
	global_position.x = round(global_position.x - GameSpeed.get_speed(speed_layer) * delta)

func oyuncu_degdi(body: Node2D) -> void:
	if body.name == "Oyuncu":
		add_child(havai_fisek.instantiate())
