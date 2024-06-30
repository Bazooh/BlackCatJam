extends CanvasModulate

signal finished_fading

const FADE_TIME : float = 0.75

var fading : bool = false

func fade_in():
	if fading:
		await finished_fading
		
	color = Color.BLACK
	var tween := get_tree().create_tween()
	tween.tween_property(self, "color", Color.WHITE, FADE_TIME)
	tween.tween_callback(finished)
	
func fade_out():
	if fading:
		await finished_fading
		
	color = Color.WHITE
	var tween := get_tree().create_tween()
	tween.tween_property(self, "color", Color.BLACK, FADE_TIME)
	tween.tween_callback(finished)

func finished():
	fading = false
	finished_fading.emit()
