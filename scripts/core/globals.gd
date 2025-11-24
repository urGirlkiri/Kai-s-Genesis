extends Node

const ENERGY_GEN_CYCLE = 20 #seconds
const GRASS_ENERGY_OUT_PER_CYCLE = 0.01 

const BUYABLES = {
		"Grass": {
		"button_path": "GameManager/Shop/Grass",
		"item_path": "res://scenes/entities/Flora/Grass.tscn",
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
