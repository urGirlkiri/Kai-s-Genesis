extends World

const EARTH_SOURCE_ID = 0

var land_expander_active := false
var placement_object: Node = null

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

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		var cost = Globals.BUYABLES["Earth"]["cost"]
		if Globals.life_force < cost:
			SignalBus.show_message.emit("Not enough Life Force to expand!", "error")
			land_expander_active = false
			return

		var click_pos = get_global_mouse_position()
		var map_coords = tile_map.local_to_map(tile_map.to_local(click_pos))

		if expand_land(map_coords):
			Globals.add_life_force(-cost)
			SignalBus.show_message.emit("Land expanded!", "success")
			land_expander_active = false

		else:
			SignalBus.show_message.emit("Cannot expand here.", "error")

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
