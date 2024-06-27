class_name IngredientEffect extends Effect


func _activate(witch) -> void:
	witch.collect_ingredient((entity as Ingredient).type)
	entity.destroy()
