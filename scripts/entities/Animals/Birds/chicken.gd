extends "res://scripts/entities/Animals/bird.gd"

func _ready():
	if not is_in_group("chicken"):
		add_to_group("chicken")
	
	wander_range = 300.0
	wander_timer_duration = 4.0
	move_speed = 80.0
	fall_speed = 500.0
	fall_value_factor = 1.5

	get_thirst_rate = 150
	cooldown_time_before_action = 15
	
	CHECK_HUNGER_AT_PERC = 0.6
	CHECK_THIRST_AT_PERC = 0.5

	nutrition_per_perk = 10

	super._ready()
