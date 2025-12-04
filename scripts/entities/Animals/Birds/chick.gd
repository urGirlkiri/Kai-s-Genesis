extends "res://scripts/entities/Animals/bird.gd"

func _ready():
	if not is_in_group("chick"):
		add_to_group("chick")
	
	wander_range = 200.0
	wander_timer_duration = 3.0
	move_speed = 100.0
	fall_speed = 500.0
	fall_value_factor = 1.0

	max_water_cap = 100
	default_cooldown_time = 8.0

	CHECK_HUNGER_AT_PERC = 0.8
	CHECK_THIRST_AT_PERC = 0.7
	
	super._ready()
