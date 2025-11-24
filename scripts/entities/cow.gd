extends Node2D

func _ready():
	if not is_in_group("cow"):
		add_to_group("cow")
