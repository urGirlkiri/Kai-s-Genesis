extends Control

const MAIN_GAME_SCENE = preload("uid://c2g0pw5amocod")

@onready var progress_bar: TextureProgressBar = $ProgressBar

func _ready() -> void:
	progress_bar.value = 0
	start_loading_animation()

func start_loading_animation() -> void:
	var tween = create_tween()
	
	tween.tween_property(progress_bar, "value", 100, 3.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)	
	tween.finished.connect(_on_loading_complete)

func _on_loading_complete() -> void:
	get_tree().change_scene_to_packed(MAIN_GAME_SCENE)
