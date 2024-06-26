class_name Ingredient extends Effect

@export var ingredient_number = 1

func _activate() -> void:
	witch.collect_ingredient(ingredient_number)
	
