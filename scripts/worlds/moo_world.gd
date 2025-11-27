extends Node2D

signal item_placed_successfully

var placing_scene: PackedScene = null
var is_placing_mode := false

@onready var click_popup_scene = preload("res://scenes/ui/ClickPopup.tscn")
@onready var tile_map: TileMapLayer = $TileMapLayer

func _ready() -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			
			var mouse_pos = get_global_mouse_position()
			
			if not is_point_walkable(mouse_pos):
				print("Clicked into the void!")
				return

			if is_placing_mode:
				finalize_placement(mouse_pos)
			else:
				Globals.life_force += Globals.CLICK_ENERGY_GAIN
				spawn_popup(mouse_pos)

func start_placement(item_path: String):
	placing_scene = load(item_path)
	is_placing_mode = true
	# todo: add a red highlight under the cursor to show placement mode

func finalize_placement(pos: Vector2):
	if placing_scene == null: 
		return
	
	if not is_point_walkable(pos):
		return

	var new_item = placing_scene.instantiate()
	#todo: auto align immaterial items like grass 
	add_child(new_item)
	new_item.global_position = pos
	
	is_placing_mode = false
	placing_scene = null
	item_placed_successfully.emit()
	queue_redraw() # Clear the drawing

func spawn_popup(pos: Vector2):
	var popup = click_popup_scene.instantiate()
	add_child(popup)
	popup.setup(pos, 1) 

func is_point_walkable(global_pos: Vector2) -> bool:
	var local_pos = tile_map.to_local(global_pos)
	var map_coords = tile_map.local_to_map(local_pos)
	
	var source_id = tile_map.get_cell_source_id(map_coords)
	
	return source_id != -1
