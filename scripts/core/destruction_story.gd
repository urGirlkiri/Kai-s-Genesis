extends Control

@onready var destroyer: Node2D = $Destroyer
@onready var anim_sprite: AnimatedSprite2D = $Destroyer/AnimatedSprite2D
@onready var label: Label = $Label

const STORY = [
	'The Milky Way is currently enjoying its greatest age of peace, a period lasting for eons.',
	'Like all things , the peace did not last',
	'A group of misfits woke up the God Of Destruction from his slumber.',
	'Having only slept for a billion years, Lord Beerus was cranky.',
	'So he went on a rampage and destroyed three quarters of the universe',
	
	# probably gave beerus oudding or something :)
	'It was only after The Supreme Kais, Gods of Creation paid a heavy price that they were able to send Beerus back to sleep.',
	# trigger the avatar scene transition 
	'However the universe is in need of restoration.'
]

const ANIMATABLE = [2,3,4]

var current_line_index := 3
var is_typing := false
var typing_speed := 0.07
var story_time := 2.4

func _ready() -> void:
	advance_story()
	
func advance_story() -> void:
	current_line_index += 1
	
	if current_line_index >= STORY.size():
		finish_intro()
		return

	index_story(current_line_index)
	
	var line_text = STORY[current_line_index]
	type_text(line_text)

func type_text(text_to_show: String) -> void:
	is_typing = true
	label.text = text_to_show
	label.visible_ratio = 0.0
	
	var duration = text_to_show.length() * typing_speed
	
	var tween = create_tween()
	tween.tween_property(label, "visible_ratio",1.0, duration)
	
	await tween.finished
	is_typing = false
	
	await get_tree().create_timer(story_time).timeout
	if current_line_index not in ANIMATABLE:
		advance_story()

func index_story(index: int) -> void:
	var goblins = get_tree().get_nodes_in_group('goblins')
	var planets = get_tree().get_nodes_in_group('planets')
	
	match index:
		0:
			anim_sprite.play("sleeping")
		1:
			for gob in goblins:
				gob.visible = true
				gob.set_physics_process(true)
				gob.animated_sprite.play('playing')
				
			anim_sprite.play("disturbed")
		2:
			for gob in goblins:
				gob.attack(destroyer.global_position)
			
			await goblins[0].attack_landed
			anim_sprite.play("awaken")
			
			advance_story()
		3:
			anim_sprite.play("cranky")
			await anim_sprite.animation_finished
			for gob in goblins:
				gob.takeBlow()
			
			advance_story()
		4:
			for p in planets:
				p.visible = true
				p.set_physics_process(true)
				p.animated_sprite.play('idle')
			
			for gob in goblins: 
				gob.queue_free()
				
			destroy_next_planet(planets)
				
func destroy_next_planet(available_planets: Array) -> void:
	if available_planets.is_empty():
		advance_story() 
		return
		
	var current_target = available_planets.pop_front()
	
	destroyer.attack(current_target)
	
	current_target.destroyed.connect(func():
		destroy_next_planet(available_planets)
	, CONNECT_ONE_SHOT)
	
func finish_intro() -> void:
	pass
