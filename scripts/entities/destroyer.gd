extends StaticBody2D

const HAKAI = preload("uid://d32s3y3gqc547")

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var right_hand_offset = Vector2(100, -15) 

func attack(target_node: Node2D):
	if target_node == null: return
	
	var direction = (target_node.global_position - global_position).normalized()
	var angle = direction.angle()
	
	animated_sprite.rotation = angle
	
	if abs(angle) > PI / 2:
		animated_sprite.flip_v = true
	else:
		animated_sprite.flip_v = false
		
	animated_sprite.play("attack")
	await animated_sprite.animation_finished
	
	var blast = HAKAI.instantiate()
	get_tree().root.add_child(blast) 
	
	var final_offset = right_hand_offset
	
	if animated_sprite.flip_v:
		final_offset.y = -final_offset.y
	
	var rotated_hand_pos = final_offset.rotated(angle)
	
	blast.global_position = global_position + rotated_hand_pos
	blast.velocity = direction 
	blast.rotation = angle
