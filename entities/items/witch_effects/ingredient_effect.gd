class_name IngredientEffect extends Effect


func _activate() -> void:
	witch.collect_ingredient((item as Ingredient).type)
	item.queue_free()
	
