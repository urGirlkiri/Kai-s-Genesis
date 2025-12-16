extends RefCounted

class_name Tool

func action(_entity):
	pass

func draw(_canvas: CanvasItem, _position: Vector2):
	pass


class AxeTool extends Tool:
	var size: Vector2 = Vector2(32, 32)
	var color: Color = Color(1, 0, 0, 1)

	func action(entity):
		if entity and entity.is_in_group("axable"):
			entity.queue_free()
	
	func draw(canvas: CanvasItem, position: Vector2):
		var half_size = size / 2
		canvas.draw_line(position - half_size, position + half_size, color, 2)
		canvas.draw_line(position + Vector2(half_size.x, -half_size.y), position + Vector2(-half_size.x, half_size.y), color, 2)
