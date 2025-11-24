extends Node2D

func _ready() -> void:
	var viewport_size = get_viewport_rect().size
	position = viewport_size / 2.5
