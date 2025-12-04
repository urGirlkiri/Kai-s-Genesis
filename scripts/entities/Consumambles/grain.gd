extends  BaseConsumable

func handle_item_part_consumed(_percent_left: float):
	sprite.rotation_degrees = randf_range(-10, 10)

func handle_item_fully_consumed():
	queue_free()