class_name MenuCamera extends Camera2D

@export var target_x : float
@export var time := 2


func transition():
	var tween := get_tree().create_tween().set_ease(Tween.EASE_IN)
	tween.tween_property(self, "position:x", target_x, time)

