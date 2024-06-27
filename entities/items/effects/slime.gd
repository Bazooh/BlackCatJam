class_name SlimeEffect extends Effect


const slime_scene = preload("res://entities/slime.tscn")


func _activate(_triggerer) -> void:
	var slime: Slime = slime_scene.instantiate()
	get_tree().root.add_child(slime)
	slime.global_position = entity.global_position
