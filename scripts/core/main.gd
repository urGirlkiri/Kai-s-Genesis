extends Node2D

@onready var life_force_label := $GameManager/LifeForce/Label
@onready var moo_world := $MooWorld

var shop_buttons = {}
var life_generation_timer := Globals.ENERGY_GEN_CYCLE
var previous_life_force := 0.0

func _ready() -> void:
	for name in Globals.BUYABLES.keys():
		var btn = get_node(Globals.BUYABLES[name]["button_path"])
		shop_buttons[name] = btn
		btn.pressed.connect(_on_buy_button_pressed.bind(name))

	previous_life_force = Globals.life_force
	add_to_group("game_managers")
	update_stats()
	
func _process(delta: float) -> void:
	update_shop_buttons()
	update_passive_income(delta)

	if Globals.life_force != previous_life_force:
		update_stats()

func update_stats():
	life_force_label.text = "Life Force: %.2f" % Globals.life_force

func update_passive_income(delta: float):
	life_generation_timer -= delta
	if life_generation_timer <= 0:
		var total_energy := 0.0
		
		total_energy += get_tree().get_nodes_in_group("grass").size() * Globals.GRASS_ENERGY_OUT_PER_CYCLE
		total_energy += get_tree().get_nodes_in_group("chick").size() * Globals.CHICK_ENERGY_OUT_PER_CYCLE
		total_energy += get_tree().get_nodes_in_group("chicken").size() * Globals.CHICKEN_ENERGY_OUT_PER_CYCLE
		total_energy += get_tree().get_nodes_in_group("cow").size() * Globals.COW_ENERGY_OUT_PER_CYCLE

		Globals.life_force += total_energy
		life_generation_timer = Globals.ENERGY_GEN_CYCLE

func update_shop_buttons():
	for name in Globals.BUYABLES.keys():
		var cost = Globals.BUYABLES[name]["cost"]
		var btn = shop_buttons[name]
		var affordable = Globals.life_force >= cost
		
		btn.disabled = not affordable
		if affordable:
			btn.text = "Buy %s (%d)" % [name, cost]
		else:
			btn.text = "%s (%d)" % [name, cost]

func _on_buy_button_pressed(item_name: String):
	var cost = Globals.BUYABLES[item_name]["cost"]

	if Globals.life_force < cost:
		SignalBus.show_message.emit("Not enough Life Force!", "error")
		return
	else:
		SignalBus.show_message.emit("Bought " + item_name + "!", "success")

	Globals.life_force -= cost
	update_stats()
	
	moo_world.start_placement(Globals.BUYABLES[item_name]["item_path"])
