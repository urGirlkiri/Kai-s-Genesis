extends Node2D

@onready var progress_bar: ProgressBar = $ProgressBar

var fill_style: StyleBoxFlat 

func _ready() -> void:
	var original_style = progress_bar.get_theme_stylebox("fill")
	
	if original_style is StyleBoxFlat:
		fill_style = original_style.duplicate()		
		progress_bar.add_theme_stylebox_override("fill", fill_style)

func set_value(value: float):
	progress_bar.value = value
	if fill_style == null: return

	if progress_bar.value >= 99:
		fill_style.corner_radius_top_right = 0
		fill_style.corner_radius_bottom_right = 0
	else:
		fill_style.corner_radius_top_right = 8
		fill_style.corner_radius_bottom_right = 8

func toggle_visibility(value: bool) -> void:
	progress_bar.visible = value
