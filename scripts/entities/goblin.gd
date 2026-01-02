extends RigidBody2D

signal attack_landed 

const SPEED = 400
const KNOCK_BACK_FORCE = 500
const ATTACK_TIME = 1.5

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var attackLocation: Vector2
var isAttacking = false
var isMoving = false

func _ready() -> void:
	self.visible = false
	self.set_physics_process(false)
	animated_sprite.stop()
	
func _process(delta: float) -> void:
	if isMoving and attackLocation != null and not isAttacking:
		
		var direction = (attackLocation - global_position).normalized()
		
		if linear_velocity.x < 0: 
			animated_sprite.flip_h = false
		else:
			animated_sprite.flip_h = true
			
		linear_velocity = direction * SPEED
		
		if animated_sprite.animation != 'move':
			animated_sprite.play('move')

func _on_target_reached(body: Node) -> void:
	if isAttacking: return 
	
	isAttacking = true
	isMoving = false 
	linear_velocity = Vector2.ZERO
	
	animated_sprite.play('attack')
	await get_tree().create_timer(ATTACK_TIME).timeout
	attack_landed.emit() 

func attack(pos: Vector2):
	if isMoving: return
	isMoving = true
	attackLocation = pos

func takeBlow():
	animated_sprite.play("blow")
	
	var direction = ( global_position - attackLocation).normalized()
	apply_central_impulse(direction * KNOCK_BACK_FORCE)
	
func die():
	animated_sprite.play("die")
	
	await animated_sprite.animation_finished
	self.queue_free()
