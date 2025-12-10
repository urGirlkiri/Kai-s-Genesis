extends World

const EARTH_SOURCE_ID = 0

const neighbor_offsets = {
	"TOP_LEFT_EARTH_COORD":  Vector2i(1, 0),
	"BOTTOM_LEFT_EARTH_COORD": Vector2i(1, 2),
	"TOP_RIGHT_EARTH_COORD": Vector2i(3, 0),
	"BOTTOM_RIGHT_EARTH_COORD": Vector2i(3, 2),
}

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

	var has_placed_tile := false

	# Check Top Left Neighbhour
	var current_pos = map_coords + neighbor_offsets['TOP_LEFT_EARTH_COORD']
	var source_id = tile_map.get_cell_source_id(current_pos)

	if source_id == EARTH_SOURCE_ID:
		pass
	else:
		tile_map.set_cell(map_coords, EARTH_SOURCE_ID, neighbor_offsets['TOP_LEFT_EARTH_COORD'])
		has_placed_tile = true
	
	# Check Top Right Neighbhour
	
	return has_placed_tile

func cancel_placement() -> void:
	if placement_object:
		placement_object.queue_free()
		placement_object = null
