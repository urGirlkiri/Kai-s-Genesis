extends Area2D

@onready var sprite = $Sprite2D

@export var max_nutrition := 20.0

var available_nutrition := 0.0

func _ready() -> void:
	available_nutrition = max_nutrition

func handle_consumption(amount: float) -> float:
	var eaten_amount = min(amount, available_nutrition)
	available_nutrition -= eaten_amount
	
	var percent_left = available_nutrition / max_nutrition

	sprite.scale = Vector2.ONE * max(0.1, percent_left)
	
	sprite.rotation_degrees = randf_range(-10, 10)
	
	if available_nutrition <= 0:
		queue_free()
		
	return eaten_amount 
