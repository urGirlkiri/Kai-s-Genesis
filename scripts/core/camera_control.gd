extends Camera2D

@export var zoom_speed := 0.1
@export var min_zoom := 0.5
@export var max_zoom := 3.0
@export var pan_speed := 1.0

func _unhandled_input(event):
	#Zoom 
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_camera(zoom_speed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_camera(-zoom_speed)

	# Panning
	elif event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			position -= event.relative / zoom

func zoom_camera(amount):
	var new_zoom = zoom + Vector2(amount, amount)
	zoom.x = clamp(new_zoom.x, min_zoom, max_zoom)
	zoom.y = clamp(new_zoom.y, min_zoom, max_zoom)
