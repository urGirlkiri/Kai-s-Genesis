extends Node2D

class_name World

enum WEATHER_STATE {
	NEUTRAL, RAINY
}

const RAIN_MATERIAL_TRES = preload("res://tres/rain.tres")

@onready var click_popup_scene = preload("res://scenes/ui/ClickPopup.tscn")
@onready var tile_map: TileMapLayer = $WorldVisuals/TileMapLayer
@onready var world_visuals: CanvasGroup = $WorldVisuals
@onready var weather_rect: ColorRect = $WorldVisuals/WeatherLayer/WeatherRect

@export var  weather_duration := 5.0

var current_weather_duration = 0

var placing_scene: PackedScene = null
var is_placing_mode := false
var is_drawing_allowed := false
var is_drawing := false
var placement_cost := 0.0
var click_threshold = 32.0

var tool_mode := false
var active_tool: Tool = null
var weather_state := WEATHER_STATE.NEUTRAL

func _ready() -> void:
	Globals.current_world = self
	current_weather_duration = weather_duration

	if world_visuals.material:
		world_visuals.material = world_visuals.material.duplicate()

	var mat = world_visuals.material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("radius", -1)

func _process(_delta: float) -> void:
	if weather_state != WEATHER_STATE.NEUTRAL:
		if current_weather_duration > 0:
			current_weather_duration -= _delta
		elif current_weather_duration <= 0:
			current_weather_duration = weather_duration
			deactivate_weather()

	if is_placing_mode or tool_mode:
		queue_redraw()

func _unhandled_input(event: InputEvent) -> void:
	var is_aborting = event is InputEventKey and (event.keycode == KEY_X and event.pressed)

	if is_aborting:
		SignalBus.show_message.emit("Placement Mode Exited", "info")
		reset_placement()

	if tool_mode:
		handle_tool_input(event)
		return

	if is_placing_mode:
		SignalBus.show_message.emit("Press X to exit placing mode", "info")
		handle_placement_input(event)
	else:
		handle_world_click_input(event)


func activate_weather():
	if weather_rect:
		weather_rect.material = RAIN_MATERIAL_TRES
		self.weather_state = WEATHER_STATE.RAINY

func deactivate_weather():
	if weather_rect:
		weather_rect.material = null
		self.weather_state = WEATHER_STATE.NEUTRAL

func handle_tool_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mouse_pos = get_global_mouse_position()
		var entity = get_hovered_entity(mouse_pos)
		if active_tool:
			active_tool.action(entity)
			if entity:
				spawn_popup(mouse_pos, -1)
	else:
		SignalBus.show_message.emit("Press X to exit tool mode", "info")

func get_hovered_entity(mouse_pos: Vector2):
	for group in ["axable"]: 
		for entity in get_tree().get_nodes_in_group(group):
			if entity is Node2D and entity.global_position.distance_to(mouse_pos) < click_threshold:
				return entity
	return null

func handle_placement_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and is_drawing:
		place_item(get_global_mouse_position())
		return

	if not event is InputEventMouseButton:
		return

	if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		reset_placement()
		return

	if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and is_drawing:
		is_drawing = false
		return

	if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mouse_pos = get_global_mouse_position()
		if not is_point_placeable(mouse_pos):
			SignalBus.show_message.emit("You can't gain life in space.", "error")
			return
		
		if is_drawing_allowed:
			is_drawing = true
			place_item(mouse_pos)
		else:
			finalize_placement(mouse_pos)

func handle_world_click_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mouse_pos = get_global_mouse_position()
		
		if not is_point_placeable(mouse_pos):
			SignalBus.show_message.emit("You can't gain life in space.", "error")
			return

		var energy_gain = Globals.CLICK_ENERGY_GAIN
		
		for buyable_name in Globals.BUYABLES:
			var buyable = Globals.BUYABLES[buyable_name]
			var group = buyable["group"]
			
			for entity in get_tree().get_nodes_in_group(group):
				if entity.global_position.distance_to(mouse_pos) < click_threshold:
					energy_gain = buyable["click_energy_gain"]
					break
			
			if energy_gain != Globals.CLICK_ENERGY_GAIN:
				break
		
		Globals.add_life_force(energy_gain)
		spawn_popup(mouse_pos, energy_gain)

func finalize_placement(raw_pos: Vector2):
	if placing_scene == null:
		return
	
	if not is_point_placeable(raw_pos):
		return

	place_item(raw_pos)

func _draw() -> void:
	if tool_mode and active_tool:
		var mouse_pos = get_global_mouse_position()
		var local_mouse_pos = to_local(mouse_pos)
		active_tool.draw(self, local_mouse_pos)
		return

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

func place_item(raw_pos: Vector2):
	if placing_scene == null:
		return

	if not is_point_placeable(raw_pos):
		return

	if Globals.life_force < placement_cost:
		SignalBus.show_message.emit("Not enough Life Force!", "error")
		reset_placement()
		return

	var final_pos = get_snapped_position(raw_pos)

	var tile_size = tile_map.tile_set.tile_size
	for child in world_visuals.get_children():
		if child is Node2D and child.global_position.distance_to(final_pos) < tile_size.x / 4:
			return

	var new_item = placing_scene.instantiate()
	
	world_visuals.add_child(new_item)
	new_item.global_position = final_pos
	Globals.add_life_force(-placement_cost)

func reset_placement():
	if is_placing_mode:
		SignalBus.show_message.emit("Placement Mode Exited", "info")

	is_placing_mode = false
	is_drawing = false
	is_drawing_allowed = false
	placing_scene = null
	placement_cost = 0.0
	tool_mode = false
	active_tool = null
	queue_redraw()

func start_placement(item_path: String):
	placing_scene = load(item_path)
	is_placing_mode = true
	is_drawing_allowed = false
	is_drawing = false
	placement_cost = 0.0

	for buyable_name in Globals.BUYABLES:
		var buyable = Globals.BUYABLES[buyable_name]
		if buyable["item_path"] == item_path:
			if buyable.has("cost"):
				placement_cost = buyable["cost"]
			if buyable.has("can_be_drawn") and buyable["can_be_drawn"]:
				is_drawing_allowed = true
			break

func spawn_popup(pos: Vector2, amount: float):
	var popup = click_popup_scene.instantiate()
	add_child(popup)
	popup.setup(pos, amount)

func dissolve_world(center_pos: Vector2 = Vector2.ZERO, duration: float = 2.0):
	for child in world_visuals.get_children():
		if child.has_method("set_use_parent_material"):
			child.set_use_parent_material(true)
		if not child.is_in_group("dissolve"):
			#todo: change the white canvas to a void texture to mimic a universal boom
			child.z_index = 0
			
		
	var mat = world_visuals.material as ShaderMaterial
	if not mat: return
	for child in world_visuals.get_children():
		if child.has_method("set_use_parent_material"):
			child.set_use_parent_material(true)

	var viewport_size = get_viewport_rect().size
	
	var uv_pos = center_pos / viewport_size
	
	mat.set_shader_parameter("position", uv_pos)

	var tween = create_tween()
	tween.tween_method(func(val): mat.set_shader_parameter("radius", val), 0.0, 1, duration)
	
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
	
	map_coords.x = int(map_coords.x / 2) * 2
	map_coords.y = int(map_coords.y / 2) * 2
	
	var centered_local_pos = tile_map.map_to_local(map_coords)
	
	return tile_map.to_global(centered_local_pos)
