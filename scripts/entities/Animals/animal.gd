extends CharacterBody2D

class_name Animal

@onready var thirst_bar: Node2D = $ThirstBar
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
	WANDER, 
	FIND_WATER, SEEK_WATER, DRINK_WATER, 
	FIND_FOOD, SEEK_FOOD, EAT_FOOD 
}

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
	if thirst_bar:
		var percent = (current_water_cap / max_water_cap) * 100
		if thirst_bar.has_method("set_value"):
			thirst_bar.set_value(percent)
		
		if thirst_bar.has_method("toggle_visibility"):
			thirst_bar.toggle_visibility(percent < 99)
