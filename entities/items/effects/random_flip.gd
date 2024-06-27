class_name RandomFlipEffect extends Effect


func _activate(_entity) -> void:
	var flip: bool = randi() % 2 == 0
	var direction: int = -1 if flip else 1

	entity.scale.x *= direction

	if entity.has_node("Effects/Drop"):
		var drop: Drop = entity.get_node("Effects/Drop")
		drop.speed.x *= direction
