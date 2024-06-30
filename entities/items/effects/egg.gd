class_name EggEffect extends Effect


const egg_scene = preload("res://entities/items/other_ingredients/egg.tscn")


func _activate(_triggerer) -> void:
	var egg: Ingredient = egg_scene.instantiate()
    
	Game.level_generator.add_child.call_deferred(egg)
	(func(): egg.global_position = entity.global_position).call_deferred()
