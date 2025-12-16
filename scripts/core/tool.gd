extends RefCounted

class_name Tool

enum ToolShape { RECT, CIRCLE, CROSS }

var shape: ToolShape = ToolShape.RECT
var size: Vector2 = Vector2(32, 32)
var color: Color = Color(1, 0, 0, 0.5)

func _init(p_shape: ToolShape = ToolShape.RECT, p_size: Vector2 = Vector2(32, 32), p_color: Color = Color(1, 0, 0, 0.5)):
	shape = p_shape
	size = p_size
	color = p_color

func action(_entity):
	pass


class AxeTool extends Tool:
	func _init():
		super._init(ToolShape.CROSS, Vector2(32, 32), Color(1, 0, 0, 1))

	func action(entity):
		if entity and entity.is_in_group("axable"):
			entity.queue_free()

