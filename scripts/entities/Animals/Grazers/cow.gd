extends "res://scripts/entities/Animals/wandering_animal.gd"

func _ready():
	if not is_in_group("cow"):
		add_to_group("cow")
	
	wander_range = 400.0
	wander_timer_duration = 5.0
	move_speed = 60.0
	fall_speed = 500.0
	fall_value_factor = 2.0
	
	max_water_cap = 220
	default_cooldown_time = 28.0
	
	super._ready()
