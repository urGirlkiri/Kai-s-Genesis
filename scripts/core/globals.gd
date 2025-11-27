extends Node

const CLICK_ENERGY_GAIN = 1.0
const ENERGY_GEN_CYCLE = 20 #seconds

const GRASS_ENERGY_OUT_PER_CYCLE = 0.1 
const CHICK_ENERGY_OUT_PER_CYCLE = 0.5 
const CHICKEN_ENERGY_OUT_PER_CYCLE = 2.5 
const COW_ENERGY_OUT_PER_CYCLE = 7.5 

const BUYABLES = {
		"Grass Patch": {
		"button_path": "GameManager/Shop/GrassPatch",
		"item_path": "res://scenes/entities/Flora/GrassPatch.tscn",
		"cost": 10
	},
	"Chick": {
		"button_path": "GameManager/Shop/Chick",
		"item_path": "res://scenes/entities/Animals/Chick.tscn",
		"cost": 25
	},
	"Chicken": {
		"button_path": "GameManager/Shop/Chicken",
		"item_path": "res://scenes/entities/Animals/Chicken.tscn",
		"cost": 100
	},
	"Cow": {
		"button_path": "GameManager/Shop/Cow",
		"item_path": "res://scenes/entities/Animals/Cow.tscn",
		"cost": 250
	}
}

@export var life_force := 0.0
