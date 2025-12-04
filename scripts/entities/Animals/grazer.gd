extends WanderingAnimal

@export var nutrition_per_cew: int = 2

@export var chew_cooldown: float = 0.0

var current_chew_cooldown: float = 0.0

func _ready():
	food_source_name = 'grass'
	super._ready()
	
func handle_eat_food(delta: float) -> void:
	velocity = Vector2.ZERO
	current_chew_cooldown -= delta

	if current_chew_cooldown <= 0.0:
		current_chew_cooldown = chew_cooldown

		if is_instance_valid(target_food_area):
			if target_food_area.has_method("handle_consumption"):
				var eaten_amount = target_food_area.handle_consumption(nutrition_per_cew)
				if eaten_amount > 0:
					current_stomach_cap += eaten_amount
				else:
					target_food_area = null
					return_to_wander_with_cooldown()
			else:
				target_food_area = null
				return_to_wander_with_cooldown()
		else:
			target_food_area = null
			return_to_wander_with_cooldown()

	if current_stomach_cap >= max_stomach_cap:
		current_stomach_cap = max_stomach_cap
		
		current_state = State.WANDER
		is_finding_food = false
		is_cooling_down = false
		target_food_area = null
