extends WanderingAnimal

@export var nutrition_per_perk: int = 5      

@export var peck_cooldown: float = 0.0

var current_peck_cooldown: float = 0.0

func _ready():
	food_source_name = 'grain'
	super._ready()
	
func handle_eat_food(delta: float) -> void:
	velocity = Vector2.ZERO
	current_peck_cooldown -= delta

	if current_peck_cooldown <= 0.0:
		current_peck_cooldown = peck_cooldown 


		if is_instance_valid(target_food_area):
			if target_food_area.has_method("handle_consumption"):
				var eaten_amount = target_food_area.handle_consumption(nutrition_per_perk)
				if eaten_amount > 0:
					current_stomach_cap += eaten_amount
	else:
		current_water_cap -= delta * 1.5
	
	if current_stomach_cap >= max_stomach_cap:
		current_stomach_cap = max_stomach_cap
		
		current_state = State.WANDER
		is_finding_food = false
		is_cooling_down = false
		target_food_area = null
