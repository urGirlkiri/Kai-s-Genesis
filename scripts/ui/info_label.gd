extends "res://scripts/ui/base_label.gd"

@export var info_color := Color.WHITE
@export var success_color := Color("55ff55") 
@export var error_color := Color("ff5555")   
@export var warning_color := Color.ORANGE

var active_warnings: Dictionary = {} 

const WARNING_TEXTS = {
	"drought": "⚠️ DROUGHT ALERT! NO WATER! ⚠️",
	"famine": "☠️ FAMINE ALERT! ANIMALS STARVING! ☠️",
	"cap_reached": "⚠️ STORAGE FULL! BUY LAND! ⚠️",
	"LIFE_OVERLOAD": "LIFE OVERLOAD"
}

func _ready() -> void:
	self.modulate.a = 0.0
	self.position.y = -50 # 
	
	SignalBus.show_message.connect(_on_show_message)
	SignalBus.set_warning.connect(_on_set_warning)

func _process(_delta: float) -> void:
	if not active_warnings.is_empty():
		var id = active_warnings.keys()[0]
		var color = warning_color
		if id == "LIFE_OVERLOAD":
			color = error_color
		if text != active_warnings[id]: 
			animate_in(active_warnings[id], color, true)
	else:
		if tween == null or not tween.is_running():
			if self.modulate.a > 0:
				animate_out()

func _on_show_message(msg_text: String, type: String = "info"):
	if not active_warnings.is_empty(): return
		
	var target_color = info_color
	match type:
		"error": target_color = error_color
		"success": target_color = success_color
	
	animate_in(msg_text, target_color, false)

func _on_set_warning(id: String, is_active: bool):
	if is_active:
		if id in WARNING_TEXTS:
			active_warnings[id] = WARNING_TEXTS[id]
	else:
		active_warnings.erase(id)
