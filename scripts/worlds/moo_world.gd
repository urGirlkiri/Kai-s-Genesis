extends Node2D

signal item_placed_successfully

var placing_scene: PackedScene = null
var is_placing_mode := false

@onready var click_popup_scene = preload("res://scenes/ui/ClickPopup.tscn")

func _ready() -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			
			if is_placing_mode:
				finalize_placement(get_global_mouse_position())
			else:
				#todo: further check if click is on placed items
				Globals.life_force += Globals.CLICK_ENERGY_GAIN
				spawn_popup(get_global_mouse_position())

func start_placement(item_path: String):
	placing_scene = load(item_path)
	is_placing_mode = true
	# todo: add a red highlight under the cursor to show placement mode

func finalize_placement(pos: Vector2):
	if placing_scene == null: 
		return

	var new_item = placing_scene.instantiate()
	#todo: check for valid placement area and if possible alignment also
	add_child(new_item)
	new_item.global_position = pos
	
	is_placing_mode = false
	placing_scene = null
	item_placed_successfully.emit()

func spawn_popup(pos: Vector2):
	var popup = click_popup_scene.instantiate()
	
	add_child(popup)

	popup.setup(pos, 1) 
