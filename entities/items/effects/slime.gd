class_name SlimeEffect extends Effect


const bomb_scene = preload("res://entities/bomb.tscn")


func _activate(_triggerer) -> void:
	var bomb: Bomb = bomb_scene.instantiate()
	get_tree().root.add_child(bomb)
	bomb.global_position = entity.global_position

	bomb.explode([target])
