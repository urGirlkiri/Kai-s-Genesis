extends CharacterBody2D

# Exported parameters for easy configuration
@export var wander_range: float = 200.0
@export var wander_timer_duration: float = 3.0
@export var move_speed: float = 100.0
@export var fall_speed: float = 500.0

var wander_timer := 0.0
var wander_direction := Vector2.ZERO
var start_position := Vector2.ZERO

var is_falling := false
var fall_velocity := 0.0

@onready var moo_world = get_parent()
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

func _ready():
	start_position = global_position
	pick_new_wander_direction()

func _physics_process(delta: float) -> void:
	if is_falling:
		handle_falling_off(delta)
		return
	
	if not check_ground():
		is_falling = true
		return
	
	# Update wander timer
	wander_timer -= delta
	if wander_timer <= 0:
		pick_new_wander_direction()
	
	velocity = wander_direction * move_speed

	var distance_from_start = global_position.distance_to(start_position)
	if distance_from_start > wander_range:
		wander_direction = (start_position - global_position).normalized()
	
	move_and_slide()

func handle_falling_off(delta: float) -> void:
	fall_velocity += fall_speed * delta
	global_position.y += fall_velocity * delta

	global_position.x += wander_direction.x * 50 * delta
	global_position.y += wander_direction.y * 70 * delta
	
	# Shrink the sprite as it falls
	scale = lerp(scale, Vector2.ZERO, 0.05)
	modulate.a = lerp(modulate.a, 0.0, 0.05)
	
	# Remove when fallen far enough or fully transparent
	if fall_velocity > 1000 or modulate.a < 0.1:
		queue_free()

func check_ground() -> bool:
	var is_on_valid_ground = moo_world.is_point_walkable(global_position)

	if not is_on_valid_ground:
		var safety_check_pos = global_position - (velocity.normalized() * 19.5)
		if moo_world.is_point_walkable(safety_check_pos):
			is_on_valid_ground = true
	
	if not is_on_valid_ground:
		var above_check_pos = global_position + Vector2(0, -19.5)
		if moo_world.is_point_walkable(above_check_pos):
			is_on_valid_ground = true
	
	return is_on_valid_ground

func pick_new_wander_direction():
	wander_timer = randf_range(wander_timer_duration * 0.5, wander_timer_duration * 1.5)
	var random_angle = randf() * TAU
	wander_direction = Vector2(cos(random_angle), sin(random_angle)).normalized()
