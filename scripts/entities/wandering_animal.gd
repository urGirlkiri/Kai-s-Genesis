extends CharacterBody2D

@onready var thirst_bar: Node2D = $ThirstBar
@onready var sense_area: Area2D = $Sensor


@export var wander_range := 200.0
@export var wander_timer_duration := 3.0
@export var move_speed := 100.0
@export var fall_speed := 500.0
@export var fall_value_factor := 1.0

@export var get_thirst_rate := 20.0
@export var cooldown_time_before_action := 5.0 # find pond,food...

var quench_thirst_rate := 0.0
var current_cooldown_time := 0.0
var is_cooling_down := false
var current_get_thirst_rate := 0.0
var target_pond_area: Area2D = null

enum State { 
	WANDER, 
	FIND_WATER, SEEK_WATER, DRINK_WATER, 
	FIND_FOOD, SEEK_FOOD,  EAT_FOOD 
}

var current_state = State.WANDER

var wander_timer := 0.0
var wander_direction := Vector2.ZERO
var start_position := Vector2.ZERO

var is_falling := false
var is_finding_pond := false
var fall_velocity := 0.0

@onready var current_world = get_parent()
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

func _ready():
	current_get_thirst_rate = get_thirst_rate
	current_cooldown_time = cooldown_time_before_action
	quench_thirst_rate = get_thirst_rate * 2.0
	start_position = global_position
	pick_new_wander_direction()

func _physics_process(delta: float) -> void:
	if is_falling:
		handle_falling_off(delta)
		return
	
	if not check_ground():
		is_falling = true
		return

	if is_cooling_down:
		current_cooldown_time -= delta
		if current_cooldown_time <= 0:
			is_cooling_down = false
			current_cooldown_time = cooldown_time_before_action

	if current_state == State.WANDER and is_cooling_down == false :
		if current_get_thirst_rate <= get_thirst_rate - 10:
			if not is_finding_pond: 
				current_state = State.FIND_WATER
				is_finding_pond = true
				
	if current_get_thirst_rate <= 0 :
		#todo: animate die of thirst
		queue_free()

	match current_state:
		State.WANDER:
			handle_wandering(delta)
		State.FIND_WATER:
			handle_find_pond(delta)
		State.SEEK_WATER:
			handle_seek_pond(delta)
		State.DRINK_WATER:
			handle_drink_water(delta)
		State.FIND_FOOD:
			pass
		State.SEEK_FOOD:
			pass 
		State.EAT_FOOD:
			pass
	
	handle_thirst_bar()
	move_and_slide()

func handle_thirst_bar():
	if thirst_bar:
		var percent = (current_get_thirst_rate / get_thirst_rate) * 100
	
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

func handle_find_pond(delta: float) -> void:
	get_thirsty(delta)

	var ponds = get_tree().get_nodes_in_group("pond")

	if ponds.size() > 0:
		var nearest_pond =  ponds[0]
		var nearest_distance = global_position.distance_to(nearest_pond.global_position)
		
		for pond in ponds:
			var dist = global_position.distance_to(pond.global_position)
			if dist < nearest_distance:
				nearest_distance = dist
				nearest_pond = pond
		
		target_pond_area = nearest_pond

		if target_pond_area != null and is_instance_valid(target_pond_area):
			current_state = State.SEEK_WATER
			if sense_area.overlaps_area(target_pond_area):
				_on_sensor_area_entered(target_pond_area)
		else:
			#todo: if thirst is low enugh, reduce speed and show tardniess
			current_state = State.WANDER
			is_finding_pond = false
			is_cooling_down = true
	else:
		current_state = State.WANDER
		is_finding_pond = false
		is_cooling_down = true

func handle_seek_pond(delta: float) -> void:
	get_thirsty(delta)

	if not is_instance_valid(target_pond_area):
		print("No valid pond found")
		current_state = State.WANDER
		is_finding_pond = false
		is_cooling_down = true
		return

	var direction_to_pond = (target_pond_area.global_position - global_position).normalized()
	velocity = direction_to_pond * move_speed


func handle_drink_water(delta: float) -> void:
	current_state = State.DRINK_WATER
	
	if current_get_thirst_rate < get_thirst_rate:
		var fill_amount_per_second = get_thirst_rate / quench_thirst_rate
		current_get_thirst_rate += fill_amount_per_second * delta
	
	if current_get_thirst_rate >= get_thirst_rate:		
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
	current_get_thirst_rate -= delta * 1.5

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

func _on_sensor_area_entered(area: Area2D) -> void:

	if current_state == State.SEEK_WATER and area == target_pond_area:
		current_state = State.DRINK_WATER
		velocity = Vector2.ZERO 

func _on_sensor_area_exited(area: Area2D) -> void:

	if area == target_pond_area and current_state == State.DRINK_WATER:
		current_state = State.SEEK_WATER 
