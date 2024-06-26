class_name Recipe extends TextureRect

@onready var ingredientBox: HBoxContainer = $Ingredients

var ingredients: Array[TextureRect] = []

func _ready():
	for child in ingredientBox.get_children():
		if child is TextureRect:
			ingredients.append(child as TextureRect)

func update_ui(recipe: Array[Ingredient.Type], collected: Array[bool]):
	if not is_node_ready():
		await ready
		
	if not recipe:
		return
	for i in range(ingredients.size()):
		var tex = ingredients[i].texture as AtlasTexture
		if i < recipe.size():
			tex.region.position.y = tex.region.size.y * int(recipe[i])
			if collected[i]:
				tex.region.position.x = tex.region.size.x
			else:
				tex.region.position.x = 0
			
func _on_witch_on_recipe_update(recipe: Array[Ingredient.Type], collected: Array[bool]):
	update_ui(recipe, collected)
