extends Node2D

@export var click_power := 1
@export var life_force := 0

@onready var life_force_label := $GameManager/LifeForce/Label
@onready var click_popup_label := preload("res://scenes/ui/ClickPopup.tscn")

const BUYABLES = {
		"Grass": {
		"button_path": "GameManager/Shop/Grass",
		"cost": 10
	},
	"Chick": {
		"button_path": "GameManager/Shop/Chick",
		"cost": 25
	},
	"Chicken": {
		"button_path": "GameManager/Shop/Chicken",
		"cost": 100
	},
	"Cow": {
		"button_path": "GameManager/Shop/Cow",
		"cost": 250
	}
}

var shop_buttons = {}

func _ready() -> void:
	for name in BUYABLES.keys():
		var btn = get_node(BUYABLES[name]["button_path"])
		shop_buttons[name] = btn
		btn.pressed.connect(_on_buy_button_pressed.bind(name))

	add_to_group("game_managers")
	update_stats()


func _process(delta: float) -> void:
	update_shop_buttons()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		generate_energy(click_power)
		pop_click_label(get_global_mouse_position(), click_power)


func update_stats():
	life_force_label.text = "Life Force: " + str(life_force)


func generate_energy(amount: int):
	life_force += amount
	update_stats()


func update_shop_buttons():
	for name in BUYABLES.keys():
		var cost = BUYABLES[name]["cost"]
		var btn = shop_buttons[name]
		
		var affordable = life_force >= cost
		
		btn.disabled = not affordable
		
		if affordable:
			btn.text = "Buy %s (%d)" % [name, cost]
		else:
			btn.text = "%s (%d)" % [name, cost]


func _on_buy_button_pressed(item_name: String):
	var cost = BUYABLES[item_name]["cost"]

	if life_force < cost:
		return

	life_force -= cost
	update_stats()
	print("Purchased:", item_name)


func pop_click_label(pos: Vector2, amount: int):
	var popup = click_popup_label.instantiate()
	get_tree().current_scene.add_child(popup)
	popup.setup(pos, amount)
