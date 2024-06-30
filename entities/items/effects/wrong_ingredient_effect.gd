class_name WrongIngredientEffect extends Effect


func _activate(witch) -> void:
	witch.collect_ingredient("Wrong")
	entity.destroy()
