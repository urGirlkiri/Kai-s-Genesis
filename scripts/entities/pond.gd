extends StaticBody2D

var drinkable_times := 3
	
func consume():
	drinkable_times -= 1
	if drinkable_times < 1:
		queue_free()
