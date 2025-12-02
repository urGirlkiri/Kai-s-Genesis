extends "res://scripts/entities/wandering_animal.gd"

func _ready():
	if not is_in_group("cow"):
		add_to_group("cow")
	
	wander_range = 400.0
	wander_timer_duration = 5.0
	move_speed = 60.0
	fall_speed = 500.0
	fall_value_factor = 2.0
	
	get_thirst_rate = 220
	cooldown_time_before_action = 28.0
	
	super._ready()
