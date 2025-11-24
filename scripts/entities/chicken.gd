extends Node2D

func _ready():
	if not is_in_group("chicken"):
		add_to_group("chicken")
