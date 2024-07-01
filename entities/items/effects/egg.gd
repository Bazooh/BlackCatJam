class_name EggEffect extends Effect


const egg_scene = preload("res://entities/items/other_ingredients/egg.tscn")

func _activate(_triggerer) -> void:
	entity.animation_player.play("boop")
	var egg : Ingredient = egg_scene.instantiate()
	entity.add_child(egg)
	
