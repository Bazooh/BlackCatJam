class_name Recipe extends TextureRect


@onready var ingredientBox: HBoxContainer = $Ingredients
@onready var nextIngredientBox: HBoxContainer = $NextIngredients

var ingredients: Array[TextureRect] = []
var next_ingredients: Array[TextureRect] = []


func _ready():
	for child in ingredientBox.get_children():
		if child is TextureRect:
			ingredients.append(child as TextureRect)
	
	for child in nextIngredientBox.get_children():
		if child is TextureRect:
			next_ingredients.append(child as TextureRect)
	
	print(ingredients == next_ingredients)


func update_ui(recipe: Array[Ingredient.Type], collected: Array[bool], next_recipe: Array[Ingredient.Type]):
	if not is_node_ready():
		await ready
	
	if not recipe:
		return
	
	for i in range(ingredients.size()):
		var recipe_texture = ingredients[i].texture as AtlasTexture
		if i < recipe.size():
			recipe_texture.region.position.y = recipe_texture.region.size.y * int(recipe[i])
			if collected[i]:
				recipe_texture.region.position.x = recipe_texture.region.size.x
			else:
				recipe_texture.region.position.x = 0
		
		var next_recipe_texture = next_ingredients[i].texture as AtlasTexture
		if i < next_recipe.size():
			next_recipe_texture.region.position.y = next_recipe_texture.region.size.y * int(next_recipe[i])
			next_recipe_texture.region.position.x = 0


func _on_witch_on_recipe_update(recipe: Array[Ingredient.Type], collected: Array[bool], next_recipe: Array[Ingredient.Type]):
	update_ui(recipe, collected, next_recipe)
