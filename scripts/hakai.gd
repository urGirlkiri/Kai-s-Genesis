extends Area2D

const SPEED = 900.0

var velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	position += velocity * SPEED * delta

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage()
		
	queue_free() 
