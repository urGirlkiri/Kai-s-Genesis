extends Area2D

class_name  BaseConsumable

@onready var sprite = $Sprite2D

@export var max_nutrition := 20.0

var available_nutrition := 0.0

func _ready() -> void:
	available_nutrition = max_nutrition

func handle_consumption(amount: float) -> float:
	var eaten_amount = min(amount, available_nutrition)
	available_nutrition -= eaten_amount
	
	var percent_left = available_nutrition / max_nutrition
	
	handle_item_part_consumed(percent_left)
		
	if available_nutrition <= 0:
		handle_item_fully_consumed()
		
	return eaten_amount 

func handle_item_part_consumed(_percent_left: float): 
	pass

func handle_item_fully_consumed():
	pass