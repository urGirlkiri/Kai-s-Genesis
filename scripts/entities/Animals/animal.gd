extends CharacterBody2D

class_name Animal

@onready var animal_bar: Node2D = $AnimalBar

@onready var sense_area: Area2D = $Sensor
@onready var current_world = get_parent()
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

@export var CHECK_THIRST_AT_PERC = 0.4
@export var CHECK_HUNGER_AT_PERC = 0.4

@export var max_water_cap := 20.0
@export var max_stomach_cap := 30.0

@export var fall_value_factor := 1.0
@export var default_cooldown_time := 5.0

var current_water_cap := 0.0
var current_stomach_cap := 0.0

var quench_thirst_rate := 0.0

var is_cooling_down := false
var current_cooldown_time := 0.0

enum State { 
	IDLE, WANDER, 
	FIND_WATER, SEEK_WATER, DRINK_WATER, 
	FIND_FOOD, SEEK_FOOD, EAT_FOOD 
}

var current_state = State.IDLE

var target_pond_area: Area2D = null
var target_food_area: Area2D = null

func _ready() -> void:
	current_water_cap = max_water_cap
	current_stomach_cap = max_stomach_cap
	current_cooldown_time = default_cooldown_time
	quench_thirst_rate = max_water_cap * 2.0

func _physics_process(delta: float) -> void:
	check_survival()
	update_ui()

	if is_cooling_down:
		current_cooldown_time -= delta
		if current_cooldown_time <= 0:
			is_cooling_down = false

func check_survival() -> void:
	if current_water_cap <= 0 or current_stomach_cap <= 0:
		die()

func die() -> void:
	if Globals:
		Globals.life_force -= fall_value_factor * 5
	queue_free()

func update_ui():
	if animal_bar:
		var thirst_perc = (current_water_cap / max_water_cap) * 100
		var hunger_perc = (current_stomach_cap / max_stomach_cap) * 100

		if animal_bar.has_method("set_value"):
			animal_bar.set_value(thirst_perc, hunger_perc)
		
		if animal_bar.has_method("toggle_visibility"):
			animal_bar.toggle_visibility( min(thirst_perc, hunger_perc) < 99 )


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
