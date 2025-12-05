extends Node2D

@onready var thirst_bar: ProgressBar = $Thirst
@onready var hunger_bar : ProgressBar = $Thirst/Hunger

var top_fill_style: StyleBoxFlat 
var top_bg_style: StyleBoxFlat 

var bottom_fill_style: StyleBoxFlat 
var bottom_bg_style: StyleBoxFlat 

func _ready() -> void:
	var original_top_fill_style = thirst_bar.get_theme_stylebox("fill")
	var original_top_bg_style = thirst_bar.get_theme_stylebox("background")
	
	var original_bottom_fill_style = hunger_bar.get_theme_stylebox("fill")
	var original_bottom_bg_style = hunger_bar.get_theme_stylebox("background")	
	
	if original_top_fill_style is StyleBoxFlat and original_top_bg_style is StyleBoxFlat:
		top_fill_style = original_top_fill_style.duplicate()		
		top_bg_style = original_top_bg_style.duplicate()
		make_top_bar(thirst_bar)
		
	if original_bottom_fill_style is StyleBoxFlat and original_bottom_bg_style is StyleBoxFlat:
		bottom_fill_style = original_bottom_fill_style.duplicate()		
		bottom_bg_style = original_bottom_bg_style.duplicate()
		make_bottom_bar(hunger_bar)

func make_top_bar(bar: ProgressBar):
	bar.z_index = 1
	bar.add_theme_stylebox_override("background", top_bg_style)

func make_bottom_bar(bar: ProgressBar):
	bar.z_index = -1
	bar.add_theme_stylebox_override("background", bottom_bg_style)

func round_corners(fill_style: StyleBoxFlat, value: float):
	if value >= 99:
		fill_style.corner_radius_top_right = 0
		fill_style.corner_radius_bottom_right = 0
	else:
		fill_style.corner_radius_top_right = 8
		fill_style.corner_radius_bottom_right = 8

func toggle_visibility(value: bool) -> void:
	thirst_bar.visible = value
	hunger_bar.visible = value

func set_value(thirst_value: int, hunger_value: int):
	var bottom_value: int
	var top_value: int

	var top_bar: ProgressBar
	var bottom_bar: ProgressBar

	if thirst_value < hunger_value:
		top_bar = thirst_bar
		top_value = thirst_value

		bottom_bar = hunger_bar
		bottom_value = hunger_value

	else:
		top_bar = hunger_bar
		top_value = hunger_value

		bottom_bar = thirst_bar
		bottom_value = thirst_value

	make_bottom_bar(bottom_bar)
	make_top_bar(top_bar)
	
	round_corners(top_fill_style, top_value)
	round_corners(bottom_fill_style, bottom_value)

	thirst_bar.value = thirst_value
	hunger_bar.value = hunger_value
