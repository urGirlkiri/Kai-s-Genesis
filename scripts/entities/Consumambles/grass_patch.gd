extends BaseConsumable

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	max_nutrition = 130.0
	if sprite.material:
		sprite.material = sprite.material.duplicate()

func handle_item_part_consumed(percent_left: float):
	var percent_gone = 1.0 - percent_left
	var mat = sprite.material as ShaderMaterial

	if sprite.material is ShaderMaterial:
		mat.set_shader_parameter("depletion_progress", percent_gone)

func  handle_item_fully_consumed():
	print("Grass Patch fully consumed.")
	remove_from_group("grass")
	add_to_group("dry_grass")
	if is_instance_valid(collision_shape_2d):
		collision_shape_2d.queue_free()
