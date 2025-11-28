extends Node

const CLICK_ENERGY_GAIN = 1.0
const ENERGY_GEN_CYCLE = 20 #seconds

const GRASS_ENERGY_OUT_PER_CYCLE = 0.1 
const CHICK_ENERGY_OUT_PER_CYCLE = 0.5 
const CHICKEN_ENERGY_OUT_PER_CYCLE = 2.5 
const COW_ENERGY_OUT_PER_CYCLE = 7.5

const BUYABLES = {
	# FLORA
	"Grass Patch": {
		"button_path": "GameManager/NatureShop/GrassPatch",
		"item_path": "res://scenes/entities/Flora/GrassPatch.tscn",
		"cost": 10,
		"group": "grass",
		"click_energy_gain": 2.0,
		"energy_per_cycle": 0.1
	},
	# ANIMALS
	"Chick": {
		"button_path": "GameManager/NatureShop/Chick",
		"item_path": "res://scenes/entities/Animals/Chick.tscn",
		"cost": 25,
		"group": "chick",
		"click_energy_gain": 2.5,
		"energy_per_cycle": 0.5
	},
	"Chicken": {
		"button_path": "GameManager/NatureShop/Chicken",
		"item_path": "res://scenes/entities/Animals/Chicken.tscn",
		"cost": 100,
		"group": "chicken",
		"click_energy_gain": 5.0,
		"energy_per_cycle": 2.5
	},
	"Cow": {
		"button_path": "GameManager/NatureShop/Cow",
		"item_path": "res://scenes/entities/Animals/Cow.tscn",
		"cost": 250,
		"group": "cow",
		"click_energy_gain": 10.0,
		"energy_per_cycle": 7.5
	},
	# STRUCTURES
	"Earth": {
		"button_path": "GameManager/NatureShop/Earth",
		"item_path": "res://scenes/entities/Structures/Earth.tscn",
		"cost": 500,
		"group": "earth",
		"click_energy_gain": 1.0,
		"energy_per_cycle": 0.0
	},
	"Fence": {
		"button_path": "GameManager/SynthShop/Fence",
		"item_path": "res://scenes/entities/Structures/Fence.tscn",
		"cost": 15,
		"group": "fence",
		"click_energy_gain": 1.0,
		"energy_per_cycle": 0.0
	},
	"Pond":{
		"button_path": "GameManager/SynthShop/Pond",
		"item_path": "res://scenes/entities/Structures/Pond.tscn",
		"cost": 15,
		"group": "pond",
		"click_energy_gain": 1.0,
		"energy_per_cycle": 0.0
	},
	# Consumables
	"Grain": {
		"button_path": "GameManager/SynthShop/Grain",
		"item_path": "res://scenes/entities/Consumables/Grain.tscn",
		"cost": 30,
		"group": "grain",
		"click_energy_gain": 0.0,
		"energy_per_cycle": 0.0
	},
}

@export var life_force := 0.0
