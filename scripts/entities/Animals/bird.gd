extends WanderingAnimal

@export var nutrition_per_perk: int = 5      

var peck_cooldown: float = 0.0


func handle_find_food(delta: float) -> void:
	get_thirsty(delta)

	var food_source = find_nearest_something_in_group("grain")

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
	
func handle_eat_food(delta: float) -> void:
	velocity = Vector2.ZERO
	peck_cooldown -= delta

	if peck_cooldown <= 0.0:
		print("Pecking food")
		peck_cooldown = eat_speed # Reset cooldown

		if is_instance_valid(target_food_area):
			if target_food_area.has_method("be_pecked"):
				var eaten_amount = target_food_area.be_pecked(nutrition_per_perk)
				if eaten_amount > 0:
					current_hunger += eaten_amount
	else:
		get_thirsty(delta)
	
	if current_hunger >= max_hunger:
		current_hunger = max_hunger
		
		current_state = State.WANDER
		is_finding_food = false
		is_cooling_down = false
		target_food_area = null