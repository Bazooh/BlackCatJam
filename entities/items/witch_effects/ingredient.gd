class_name Ingredient extends Effect

enum IngredientType {Pear, Bottle, Mushroom}
@export var ingredient : IngredientType

func _activate() -> void:
	witch.collect_ingredient(ingredient)
	item.queue_free()
	
