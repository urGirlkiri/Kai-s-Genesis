extends "res://scripts/entities/wandering_animal.gd"

func _ready():
	if not is_in_group("chick"):
		add_to_group("chick")
	
	wander_range = 200.0
	wander_timer_duration = 3.0
	move_speed = 100.0
	fall_speed = 500.0
	fall_value_factor = 1.0

	get_thirst_rate = 200.0
	quench_thirst_rate = get_thirst_rate * 2.0
	distance_to_drink_from_pond = 15.0
	
	super._ready()
