extends Label

var tween: Tween
var initial_y: float
var offscreen_y: float

func animate_in(msg_text: String, color: Color, is_permanent: bool):
	if tween: tween.kill()
	tween = create_tween()
	
	self.text = msg_text
	self.modulate = color 
	
	tween.parallel().tween_property(self, "position:y", initial_y, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "modulate:a", 1.0, 0.3)
	
	if not is_permanent:
		tween.tween_interval(2.5)
		tween.tween_callback(animate_out)

func animate_out():
	var exit_tween = create_tween()
	exit_tween.parallel().tween_property(self, "position:y", offscreen_y, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	exit_tween.parallel().tween_property(self, "modulate:a", 0.0, 0.3)
