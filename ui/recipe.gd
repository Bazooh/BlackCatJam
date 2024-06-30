class_name Recipe extends TextureRect

@export var show_next := true

@onready var ingredientBox: HBoxContainer = $Ingredients
@onready var nextIngredientBox: HBoxContainer = $NextIngredients
@onready var next: TextureRect = $Next

var ingredients: Array[TextureRect] = []
var next_ingredients: Array[TextureRect] = []


func _ready():
	next.visible = show_next;
	nextIngredientBox.visible = show_next;
	
	for child in ingredientBox.get_children():
		if child is TextureRect:
			ingredients.append(child as TextureRect)
	
	for child in nextIngredientBox.get_children():
		if child is TextureRect:
			next_ingredients.append(child as TextureRect)


func get_item_texture(item_name: String) -> Texture:
	var item = Game.witch.name_to_item[item_name]

	if item is Ingredient and item.ingredient_texture != null:
		return item.ingredient_texture
	
	return item.get_node("Sprite").texture


func update_ui(recipe: Array[String], collected: Array[bool], next_recipe: Array[String]):
	if not is_node_ready():
		await ready
	
	if not recipe:
		return
	
	for i in range(ingredients.size()):
		ingredients[i].texture.region = get_item_texture(recipe[i]).region

		if collected[i]:
			ingredients[i].texture.region.position.x = ingredients[i].texture.region.size.x
		
		next_ingredients[i].texture.region = get_item_texture(next_recipe[i]).region
		next_ingredients[i].texture.region.position.x = next_ingredients[i].texture.region.size.x * 2

		# var recipe_texture = ingredients[i].texture as AtlasTexture
		# if i < recipe.size():
		# 	recipe_texture.region.position.y = recipe_texture.region.size.y * int(recipe[i])
		# 	if collected[i]:
		# 		recipe_texture.region.position.x = recipe_texture.region.size.x
		# 	else:
		# 		recipe_texture.region.position.x = 0
		
		# var next_recipe_texture = next_ingredients[i].texture as AtlasTexture
		# if i < next_recipe.size():
		# 	next_recipe_texture.region.position.y = next_recipe_texture.region.size.y * int(next_recipe[i])
		# 	next_recipe_texture.region.position.x = next_recipe_texture.region.size.x * 2


func _on_witch_on_recipe_update(recipe: Array[String], collected: Array[bool], next_recipe: Array[String]):
	update_ui(recipe, collected, next_recipe)
