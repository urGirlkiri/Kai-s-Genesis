extends World

func is_point_placeable(global_pos: Vector2) -> bool:
	var local_pos = tile_map.to_local(global_pos)
	var map_coords = tile_map.local_to_map(local_pos)
	
	var source_id = tile_map.get_cell_source_id(map_coords)
	
	return source_id != -1

func is_point_walkable(global_pos: Vector2) -> bool:
	return is_point_placeable(global_pos)
	
