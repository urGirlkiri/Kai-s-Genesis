extends Node2D

@export var click_power := 1
@export var life_force := 0

@onready var life_force_label := $LevelStats/Panel/LifeForce
@onready var click_popup_label := preload("res://scenes/ui/ClickPopup.tscn")

func _ready() -> void:
	update_stats()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		generate_energy(click_power)
		pop_click_label(get_global_mouse_position(), click_power)

func update_stats():
	life_force_label.text = "Life Force: " + str(life_force)

func generate_energy(amount: int):
	life_force += amount
	update_stats()

func pop_click_label(pos: Vector2, amount: int):
	var popup = click_popup_label.instantiate()
	get_tree().current_scene.add_child(popup)
	popup.setup(pos, amount)
