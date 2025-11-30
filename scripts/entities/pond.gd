extends StaticBody2D

var drinkable_times := 3

func _ready() -> void:
	add_to_group("pond")

func consume():
	drinkable_times -= 1
	if drinkable_times < 10:
		queue_free()
