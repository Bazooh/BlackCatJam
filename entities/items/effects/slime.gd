class_name SlimeEffect extends Effect


const slime_scene = preload("res://entities/slime.tscn")
const spawn_y := 145

func _activate(_triggerer) -> void:
	var slime: Slime = slime_scene.instantiate()
	Game.level.add_child(slime)
	slime.global_position = Vector2(entity.global_position.x, spawn_y)
