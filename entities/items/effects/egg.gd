class_name EggEffect extends Effect


const egg_scene = preload("res://entities/items/other_ingredients/egg.tscn")

func _activate(_triggerer) -> void:
	
	var egg : Ingredient = egg_scene.instantiate()
	entity.add_child(egg)
	
