extends Control

@onready var destroyer: Node2D = $Destroyer
@onready var label: Label = $Label

const STORY = [
	# sleeping state
	'The Milky Way is currently enjoying its greatest age of peace, a period lasting for eons.',
	# show him being woke up
	'Until a group of misfits woke up the God Of Destruction from his slumber.',
	# waking up and going beserk
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
#var typing_speed :=

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
	
	var duration = text_to_show.length() * 0.05 
	
	var tween = create_tween()
	tween.tween_property(label, "visible_ratio", 1.0, duration)
	
	await tween.finished
	is_typing = false
	
	await get_tree().create_timer(2.0).timeout
	advance_story()

func index_story(index: int) -> void:
	var tween = create_tween()
	
	match index:
		0: 
			print("sleeping")
		1: 
			print("woke up")

func finish_intro() -> void:
	pass
