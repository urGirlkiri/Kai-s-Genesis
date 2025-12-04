extends BaseConsumable

func handle_item_part_consumed(percent_left: float):
	sprite.scale = Vector2.ONE * max(0.1, percent_left)
	sprite.rotation_degrees = randf_range(-10, 10)

func handle_item_fully_consumed():
	queue_free()
