extends Node2D

func _ready():
	if not is_in_group("grass"):
		add_to_group("grass")
