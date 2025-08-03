extends Sprite2D

@export var konteynerler : Array[Texture2D] = []
@onready var alan = $alan
const havai_fisek = preload("res://havai_fisek.tscn")

const move_speed = 8.0

func _ready() -> void:
	texture = konteynerler.pick_random()

func _physics_process(delta: float) -> void:
	position.x -= move_speed

func oyuncu_degdi(body : Node2D) -> void:
	if(body.name == "Oyuncu"):
		add_child(havai_fisek.instantiate())
