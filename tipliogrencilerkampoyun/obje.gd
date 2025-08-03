extends Timer

@export var arkaplan_nesneleri : Array[Texture] = []
@onready var arkaplan_nesnesi = preload("res://arkaplan_nesnesi.tscn")

func _init() -> void:
	wait_time = 2

func zaman_dolunca() -> void:
	wait_time = randf_range(4, 5)
	var nesne = arkaplan_nesnesi.instantiate()
	nesne.texture = arkaplan_nesneleri.pick_random() 
	nesne.position.x = get_viewport().get_camera_2d().get_viewport_rect().end.x
	add_child(nesne)
