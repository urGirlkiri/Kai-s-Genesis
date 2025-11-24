extends Node2D

var time_until_generation := Globals.ENERGY_GEN_CYCLE
var energy_per_generation :=  Globals.GRASS_ENERGY_OUT_PER_CYCLE

func _process(delta):
	time_until_generation -= delta
	
	if time_until_generation <= 0:
		var game_manager = get_tree().get_first_node_in_group("game_managers")
		
		if game_manager:
			game_manager.generate_energy(ceil(energy_per_generation))
		
		time_until_generation =  Globals.ENERGY_GEN_CYCLE

func _ready():
	if not is_in_group("grass"):
		add_to_group("grass")
