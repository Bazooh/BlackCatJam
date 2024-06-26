class_name Ingredient extends Effect

enum IngredientType {Temp1, Temp2, Temp3}
@export var ingredient : IngredientType

func _activate() -> void:
	witch.collect_ingredient(ingredient)
	item.queue_free()
	
