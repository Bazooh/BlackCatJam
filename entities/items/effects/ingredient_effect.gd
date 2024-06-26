class_name IngredientEffect extends Effect


func _activate(witch) -> void:
	witch.collect_ingredient((item as Ingredient).type)
	item.destroy()
