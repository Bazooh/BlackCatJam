class_name AnimationEffect extends Effect


@export var animation_name: String


func _activate(triggerer) -> void:
	if triggerer is Cat:
		entity.animation_player.speed_scale = sign(triggerer.scale.x)

	entity.animation_player.play(animation_name)