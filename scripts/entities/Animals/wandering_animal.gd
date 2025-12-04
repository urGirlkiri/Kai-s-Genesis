extends Animal

class_name WanderingAnimal

@export var wander_range := 200.0
@export var wander_timer_duration := 3.0

@export var move_speed := 100.0
@export var fall_speed := 500.0

@export var food_source_name := ""
@export var eat_speed := 5.0 

var current_state = State.WANDER

var wander_timer := 0.0
var wander_direction := Vector2.ZERO
var start_position := Vector2.ZERO

var is_falling := false
var is_finding_pond := false
var fall_velocity := 0.0
var is_finding_food := false

func _ready():
	super._ready()
	food_source_name = food_source_name.to_lower()
	start_position = global_position
	pick_new_wander_direction()

func _physics_process(delta: float) -> void:
	current_stomach_cap -= delta * 0.5
	print("Hunger: ", current_stomach_cap)

	if is_falling:
		handle_falling_off(delta)
		return
	
	if not check_ground():
		is_falling = true
		return

	if current_state == State.WANDER and is_cooling_down == false:
		if current_water_cap <= max_water_cap * CHECK_THIRST_AT_PERC:
			pass
			# if not is_finding_pond:
			# 	current_state = State.FIND_WATER
			# 	is_finding_pond = true

		if current_stomach_cap <= max_stomach_cap * CHECK_HUNGER_AT_PERC:
			if not is_finding_food:
				current_state = State.FIND_FOOD
				is_finding_food = true
				
	match current_state:
		State.WANDER:
			handle_wandering(delta)
		State.FIND_WATER:
			print("Finding Pond")
			handle_find_pond(delta)
		State.SEEK_WATER:
			print("Seeking Pond")
			handle_seek_pond(delta)
		State.DRINK_WATER:
			handle_drink_water(delta)
		State.FIND_FOOD:
			print("Finding Food")
			handle_find_food(delta)
		State.SEEK_FOOD:
			print("Seeking Food")
			handle_seek_food(delta)
		State.EAT_FOOD:
			print("Eating Food")
			handle_eat_food(delta)
	
	handle_thirst_bar()
	move_and_slide()

func handle_thirst_bar():
	if thirst_bar:
		var percent = (current_water_cap / max_water_cap) * 100
	
		thirst_bar.set_value(percent)
			
		if percent >= 99:
			thirst_bar.toggle_visibility(false)
		else:
			thirst_bar.toggle_visibility(true)
	
func handle_falling_off(delta: float) -> void:
	fall_velocity += fall_speed * delta
	global_position.y += fall_velocity * delta

	global_position.x += wander_direction.x * 50 * delta
	global_position.y += wander_direction.y * 70 * delta
	
	# Shrink the sprite as it falls
	scale = lerp(scale, Vector2.ZERO, 0.05)
	modulate.a = lerp(modulate.a, 0.0, 0.05)
	
	# Remove when fallen far enough or fully transparent
	if fall_velocity > 1000 or modulate.a < 0.1:
		queue_free()
		Globals.life_force -= fall_value_factor * 10

func handle_find_food(delta: float) -> void:
	get_thirsty(delta)

	var food_source = find_nearest_something_in_group(food_source_name)

	if food_source != null:
		SignalBus.set_warning.emit("famine", false)
		
		target_food_area = food_source
		current_state = State.SEEK_FOOD
		
		if sense_area.overlaps_area(target_food_area):
			_on_sensor_area_entered(target_food_area)
	else:
		SignalBus.set_warning.emit("famine", true)
		return_to_wander_with_cooldown()

func handle_seek_food(delta: float) -> void:
	get_thirsty(delta)
	
	if not is_instance_valid(target_food_area):
		return_to_wander_with_cooldown()
		return

	var direction = (target_food_area.global_position - global_position).normalized()
	velocity = direction * move_speed

func handle_eat_food(_delta: float) -> void:
	pass

func handle_find_pond(delta: float) -> void:
	get_thirsty(delta)

	var nearest_pond = find_nearest_something_in_group("pond") 

	if (nearest_pond != null):
		SignalBus.set_warning.emit("drought", false)
		
		target_pond_area = nearest_pond
		current_state = State.SEEK_WATER
		
		if sense_area.overlaps_area(target_pond_area): 
			_on_sensor_area_entered(target_pond_area)   
			
	else:
		SignalBus.set_warning.emit("drought", true)
		return_to_wander_with_cooldown()

func handle_seek_pond(delta: float) -> void:
	get_thirsty(delta)

	if not is_instance_valid(target_pond_area):
		print("No valid pond found")
		return_to_wander_with_cooldown()
		return

	var direction_to_pond = (target_pond_area.global_position - global_position).normalized()
	velocity = direction_to_pond * move_speed


func handle_drink_water(delta: float) -> void:
	current_state = State.DRINK_WATER
	
	if current_water_cap < max_water_cap:
		var fill_amount_per_second = max_water_cap / quench_thirst_rate
		current_water_cap += fill_amount_per_second * delta
	
	if current_water_cap >= max_water_cap:
		current_state = State.WANDER
		is_finding_pond = false
		is_cooling_down = false
		
		if is_instance_valid(target_pond_area):
			var pond_body = target_pond_area.get_parent()
			if pond_body.has_method("consume"):
				pond_body.consume()
		
func handle_wandering(delta: float) -> void:
	wander_timer -= delta
	get_thirsty(delta)

	if wander_timer <= 0:
		pick_new_wander_direction()
	
	velocity = wander_direction * move_speed

	var distance_from_start = global_position.distance_to(start_position)
	if distance_from_start > wander_range:
		wander_direction = (start_position - global_position).normalized()

func get_thirsty(delta: float) -> void:
	current_water_cap -= delta * 1.5

func check_ground() -> bool:
	var is_on_valid_ground = current_world.is_point_walkable(global_position)

	if not is_on_valid_ground:
		var safety_check_pos = global_position - (velocity.normalized() * 19.5)
		if current_world.is_point_walkable(safety_check_pos):
			is_on_valid_ground = true
	
	if not is_on_valid_ground:
		var above_check_pos = global_position + Vector2(0, -19.5)
		if current_world.is_point_walkable(above_check_pos):
			is_on_valid_ground = true
	
	return is_on_valid_ground

func pick_new_wander_direction():
	wander_timer = randf_range(wander_timer_duration * 0.5, wander_timer_duration * 1.5)
	var random_angle = randf() * TAU
	wander_direction = Vector2(cos(random_angle), sin(random_angle)).normalized()

func return_to_wander_with_cooldown():
	current_state = State.WANDER
	is_finding_pond = false
	is_finding_food = false 
	is_cooling_down = true
	current_cooldown_time = default_cooldown_time

func find_nearest_something_in_group(group_name: String) -> Area2D:
	var items = get_tree().get_nodes_in_group(group_name)
	
	if items.size() == 0:
		return null
	
	var nearest_item = items[0]
	var nearest_distance = global_position.distance_to(nearest_item.global_position)
	
	for item in items:
		var dist = global_position.distance_to(item.global_position)
		if dist < nearest_distance:
			nearest_distance = dist
			nearest_item = item
	
	return nearest_item

func _on_sensor_area_entered(area: Area2D) -> void:
	print("Sensor detected area: ", area.name)

	if current_state == State.SEEK_WATER and area == target_pond_area:
		current_state = State.DRINK_WATER
		velocity = Vector2.ZERO
	
	if current_state == State.SEEK_FOOD and area == target_food_area:
		current_state = State.EAT_FOOD
		velocity = Vector2.ZERO

func _on_sensor_area_exited(area: Area2D) -> void:
	if area == target_pond_area and current_state == State.DRINK_WATER:
		current_state = State.SEEK_WATER
	
	if area == target_food_area and current_state == State.EAT_FOOD:
		current_state = State.SEEK_FOOD
