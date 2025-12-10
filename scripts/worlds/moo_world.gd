extends World

const EARTH_SOURCE_ID = 0

var land_expander_active := false
var placement_object: Node = null
var has_placed_tile := false

func is_point_placeable(global_pos: Vector2) -> bool:
	var local_pos = tile_map.to_local(global_pos)
	var map_coords = tile_map.local_to_map(local_pos)
	
	var source_id = tile_map.get_cell_source_id(map_coords)
	
	return source_id != -1

func is_point_walkable(global_pos: Vector2) -> bool:
	return is_point_placeable(global_pos)

func _unhandled_input(event: InputEvent) -> void:
	if not land_expander_active:
		super._unhandled_input(event)
		return

	var is_click = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed
	
	var is_drag = event is InputEventMouseMotion and (event.button_mask & MOUSE_BUTTON_MASK_LEFT)

	var is_aborting = event is InputEventKey and (event.keycode == KEY_X and event.pressed)

	if is_click or is_drag:		
		attempt_place_land(get_global_mouse_position())
	elif is_aborting:
		reset_placement_state()
	else:
		if not has_placed_tile:
			SignalBus.show_message.emit("Click and Drag to place land", "info")
		else:
			SignalBus.show_message.emit("Press X to exit placing mode.", "info")


func attempt_place_land(global_pos: Vector2) -> void:
	var cost = Globals.BUYABLES["Earth"]["cost"]
	
	if Globals.life_force < cost:
		reset_placement_state()
		SignalBus.show_message.emit("Not enough Life Force!", "error")
		return

	var map_coords = tile_map.local_to_map(tile_map.to_local(global_pos))

	if expand_land(map_coords):
		Globals.add_life_force(-cost)	
		has_placed_tile = true	

func reset_placement_state():
	land_expander_active = false
	has_placed_tile = false

func expand_land(map_coords: Vector2i) -> bool:
	var source_id = tile_map.get_cell_source_id(map_coords)
	
	if source_id != -1: 
		return false

	tile_map.set_cells_terrain_connect([map_coords], 0, 0, false)
	
	return true
	
func cancel_placement() -> void:
	if placement_object:
		placement_object.queue_free()
		placement_object = null
