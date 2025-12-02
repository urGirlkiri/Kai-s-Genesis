extends StaticBody2D

var drinkable_times := 3

func _ready() -> void:
	add_to_group("pond")
	
func _process(delta: float) -> void:
	print("Can be consumed: " + str(drinkable_times) + " times")

func consume():
	drinkable_times -= 1
	if drinkable_times < 1:
		queue_free()
