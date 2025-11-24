extends Node2D

@export var click_power: int = 1
@export var life_force: int = 0

@onready var life_force_label: Label = $Gamestats/LifeForce

func _ready() -> void:
	update_stats()

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		generate_energy(click_power)
			
func generate_energy(amount: int):
	life_force += amount
	update_stats()

func update_stats():
	life_force_label.text = "Life Force: " + str(life_force)
