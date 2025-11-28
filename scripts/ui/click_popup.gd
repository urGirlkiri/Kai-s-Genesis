extends Node2D

@export var rise_distance := 40.0
@export var duration := 1

@onready var text_label: Label = $PopText
var start_position := Vector2.ZERO

func setup(pos: Vector2, amount: int):
	global_position = pos
	start_position = pos
	text_label.text = "+" + str(amount)
	text_label.modulate.a = 1.0

func _process(delta: float) -> void:
	global_position.y -= (rise_distance * delta)

	text_label.modulate.a -= delta / duration
	
	if text_label.modulate.a <= 0:
		queue_free()
