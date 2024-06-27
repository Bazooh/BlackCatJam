class_name AnimationEffect extends Effect


@export var animation_name: String


func _activate(_entity) -> void:
	if _entity is Cat:
		item.animation_player.speed_scale = sign(_entity.scale.x)

	item.animation_player.play(animation_name)