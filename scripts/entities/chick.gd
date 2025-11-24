extends Node2D

func _ready():
	if not is_in_group("chick"):
		add_to_group("chick")
