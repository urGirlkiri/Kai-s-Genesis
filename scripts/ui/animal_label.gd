extends "res://scripts/ui/base_label.gd"

@export var happy_color := Color("55ff55") 
@export var sad_color := Color("ff5555")   

func _ready() -> void:
	initial_y = position.y
	offscreen_y = initial_y + 100
	
	self.modulate.a = 0.0
	self.position.y = offscreen_y

func show_status(status_text: String, is_happy: bool):
	var color = sad_color
	if is_happy:
		color = happy_color
	animate_in(status_text, color, false)
