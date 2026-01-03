extends StaticBody2D

const HAKAI = preload("uid://d32s3y3gqc547")

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var right_hand_offset = Vector2(100, -15) 

func attack(target_node: Node2D):
	if target_node == null: return
	
	var direction = (target_node.global_position - global_position).normalized()
	
	if direction.x < 0:
		animated_sprite.flip_h = true 
	else:
		animated_sprite.flip_h = false
		
	animated_sprite.play("attack")
	await animated_sprite.animation_finished
	
	var blast = HAKAI.instantiate()
	get_tree().root.add_child(blast) 
	
	var current_hand_pos = Vector2.ZERO
	
	if animated_sprite.flip_h:
		current_hand_pos = Vector2(-right_hand_offset.x, right_hand_offset.y)
	else:
		current_hand_pos = right_hand_offset
	
	blast.global_position = global_position + current_hand_pos
	
	blast.velocity = direction 
	blast.rotation = direction.angle()
