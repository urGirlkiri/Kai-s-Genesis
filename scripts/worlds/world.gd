extends Node2D

class_name World

var placing_scene: PackedScene = null
var is_placing_mode := false

@onready var click_popup_scene = preload("res://scenes/ui/ClickPopup.tscn")
@onready var tile_map: TileMapLayer = $WorldVisuals/TileMapLayer
@onready var world_visuals: CanvasGroup = $WorldVisuals

func _ready() -> void:
	if world_visuals.material:
		world_visuals.material = world_visuals.material.duplicate()

	var mat = world_visuals.material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("radius", -0.1)

func _process(_delta: float) -> void:
	if is_placing_mode:
		queue_redraw()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			
			var mouse_pos = get_global_mouse_position()
			
			if not is_point_placeable(mouse_pos):
				print("Clicked into the void!")
				return

			if is_placing_mode:
				finalize_placement(mouse_pos)
			else:
				var energy_gain = Globals.CLICK_ENERGY_GAIN
				var click_threshold = 32.0  # pixels
				
				for buyable_name in Globals.BUYABLES:
					var buyable = Globals.BUYABLES[buyable_name]
					var group = buyable["group"]
					
					for entity in get_tree().get_nodes_in_group(group):
						if entity.global_position.distance_to(mouse_pos) < click_threshold:
							energy_gain = buyable["click_energy_gain"]
							break
					
					if energy_gain != Globals.CLICK_ENERGY_GAIN:
						break
				
				Globals.life_force += energy_gain
				spawn_popup(mouse_pos, energy_gain)

func _draw() -> void:
	if is_placing_mode:
		var mouse_pos = get_global_mouse_position()
		
		var snapped_pos = get_snapped_position(mouse_pos)
		
		var color = Color(0, 1, 0, 0.5) 
		if not is_point_placeable(mouse_pos):
			color = Color(1, 0, 0, 0.5) 
		
		var tile_size = Vector2(tile_map.tile_set.tile_size)
		var local_snapped_pos = to_local(snapped_pos)
		var rect_top_left = local_snapped_pos - (tile_size / 2)
		
		draw_rect(Rect2(rect_top_left, tile_size), color, true)

func start_placement(item_path: String):
	placing_scene = load(item_path)
	is_placing_mode = true

func finalize_placement(raw_pos: Vector2):
	if placing_scene == null: 
		return
	
	if not is_point_placeable(raw_pos):
		return

	var new_item = placing_scene.instantiate()
	
	var final_pos = get_snapped_position(raw_pos)
	
	add_child(new_item)
	new_item.global_position = final_pos
	
	is_placing_mode = false
	placing_scene = null
	queue_redraw() 

func spawn_popup(pos: Vector2, amount: float):
	var popup = click_popup_scene.instantiate()
	add_child(popup)
	popup.setup(pos, amount) 

func dissolve_world(center_pos: Vector2 = Vector2.ZERO):
	var mat = world_visuals.material as ShaderMaterial
	if not mat: return

	# for child in get_children():
	# 	if child.has_method("set_use_parent_material"):
	# 		child.set_use_parent_material(true)


	var viewport_size = get_viewport_rect().size
	
	var uv_pos = center_pos / viewport_size
	
	mat.set_shader_parameter("position", uv_pos)

	var tween = create_tween()
	tween.tween_method(func(val): mat.set_shader_parameter("radius", val), 0.0, 1, 2.0)
	
	set_process_unhandled_input(false)

func is_point_placeable(_global_pos: Vector2) -> bool:
	return true

func is_point_walkable(_global_pos: Vector2) -> bool:
	return true

func get_current_world():
	return self

func get_snapped_position(global_pos: Vector2) -> Vector2:
	var local_pos = tile_map.to_local(global_pos)
	var map_coords = tile_map.local_to_map(local_pos)
	
	var centered_local_pos = tile_map.map_to_local(map_coords)
	
	return tile_map.to_global(centered_local_pos)
