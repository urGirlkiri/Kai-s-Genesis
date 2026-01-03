extends StaticBody2D

signal destroyed

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	self.visible = false
	animated_sprite.stop()

func take_damage() -> void:
	animated_sprite.play("locked")
	await animated_sprite.animation_finished
	
	destroyed.emit()
	animated_sprite.play("barren")
