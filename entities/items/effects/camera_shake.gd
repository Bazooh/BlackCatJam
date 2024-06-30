class_name CameraShakeEffect extends Effect


@export var strength: float = 10.0
@export var duration: float = 0.5

var current_strength: float = 0.0


func _activate(_triggerer) -> void:
	current_strength = strength


func _process(delta) -> void:
	if current_strength > 0:
		Game.camera.offset = Vector2(randf() * current_strength, randf() * current_strength)
		current_strength = max(0, current_strength - delta / duration * strength)
