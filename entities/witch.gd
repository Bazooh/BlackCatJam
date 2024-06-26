class_name Witch extends Area2D

signal on_recipe_update(recipe, collected)

@export var speed : float = 100

@export var possible_ingredients : Array[Ingredient.IngredientType] = []
var recipe : Array[Ingredient.IngredientType] = []

var collected = 0

const size : float = 30
const edge_x : float = 256

var min_x : float
var max_x : float

func _ready():
	min_x = size / 2
	max_x = edge_x - size / 2
	
	create_recipe()

func _process(delta):
	var input : int = (int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left")))
	position.x += speed * delta * input
	position.x = clamp(position.x, min_x, max_x)

func create_recipe():
	recipe = []
	for i in range(3):
		var random_ingredient = possible_ingredients.pick_random()
		recipe.append(random_ingredient)
	collected = 0
	on_recipe_update.emit(recipe, collected)
	
	
func collect_ingredient(type: Ingredient.IngredientType):
	if not recipe:
		return
	
	if recipe.size() <= collected:
		return
		
	if type == recipe[collected]:
		collected += 1
		if collected == recipe.size():
			print("Win :D")
			create_recipe()
		else:
			print("Correct :)")
			on_recipe_update.emit(recipe, collected)
	else:
		print("Incorrect :(")
