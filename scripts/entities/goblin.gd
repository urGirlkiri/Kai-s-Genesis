extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	self.visible = false
	self.set_physics_process(false)
	animated_sprite.stop()
