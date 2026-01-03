extends StaticBody2D

const HAKAI = preload("uid://d32s3y3gqc547")

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func attack(target_node: Node2D):
	if target_node == null: return
	
	var direction = (target_node.global_position - global_position).normalized()
	
	animated_sprite.play("attack")
	await animated_sprite.animation_finished
	
	var blast = HAKAI.instantiate()
	
	get_tree().root.add_child(blast) 
	
	blast.global_position = global_position + (direction * 50.0)
	
	blast.velocity = direction 
	blast.rotation = direction.angle()
