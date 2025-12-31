extends Control

@onready var destroyer: Node2D = $Destroyer
@onready var anim_sprite: AnimatedSprite2D = $Destroyer/AnimatedSprite2D
@onready var label: Label = $Label

const STORY = [
	'The Milky Way is currently enjoying its greatest age of peace, a period lasting for eons.',
	'Like all things , the peace did not last',
	'A group of misfits woke up the God Of Destruction from his slumber.',
	'Having only slept for a billion years, Lord Beerus was cranky.',
	# play the planet destruction sequence
	'So he went on a rampage and destroyed three quarters of the universe',
	# probably gave beerus oudding or something :)
	'It was only after The Supreme Kais, Gods of Creation paid a heavy price that they were able to send Beerus back to sleep.',
	# trigger the avatar scene transition 
	'However the universe is in need of restoration.'
]

var current_line_index := -1
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
	type_text(line_text, current_line_index)

func type_text(text_to_show: String, index : int) -> void:
	is_typing = true
	label.text = text_to_show
	label.visible_ratio = 0.0
	
	var duration = text_to_show.length() * typing_speed
	
	var tween = create_tween()
	tween.tween_property(label, "visible_ratio",1.0, duration)
	
	await tween.finished
	is_typing = false
	
	await get_tree().create_timer(story_time).timeout
	if current_line_index not in [2]:
		advance_story()

func index_story(index: int) -> void:
	match index:
		0:
			anim_sprite.play("sleeping")
		1:
			for gob in get_tree().get_nodes_in_group('goblins'):
				gob.visible = true
				gob.set_physics_process(true)
				gob.animated_sprite.play('playing')
				
			anim_sprite.play("disturbed")
		2:
			var goblins = get_tree().get_nodes_in_group('goblins')
			for gob in goblins:
				gob.attack(destroyer.global_position)
			
			await goblins[0].attack_landed
			anim_sprite.play("awaken")
			
			await anim_sprite.animation_finished
			advance_story()
			
		3:
			anim_sprite.play("cranky")		
			#await anim_sprite.animation_finished
			#advance_story()

func finish_intro() -> void:
	pass
