extends "res://scripts/entities/wandering_animal.gd"

func _ready():
	if not is_in_group("cow"):
		add_to_group("cow")
	
	wander_range = 400.0
	wander_timer_duration = 5.0
	move_speed = 60.0
	fall_speed = 500.0
	
	super._ready()
