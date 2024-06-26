class_name Witch extends Area2D

signal on_recipe_update(recipe: Array[Ingredient.Type], collected: Array[bool], next_recipe: Array[Ingredient.Type])
signal on_lives_update(lives: int)
signal on_score_update(score: int)
signal on_game_over(score: int)

@export var speed: float = 100.0

@export var max_lives: int = 3
var ingredients_scene := {}
var ingredient_types: Array[Ingredient.Type]
var recipe: Array[Ingredient.Type] = []
var next_recipe: Array[Ingredient.Type] = []

var lives: int = 3
var collected: Array[bool] = []

var score: int= 0

const size: float = 30.0
const edge_x: float = 256.0

const min_x: float = size / 2
const max_x: float = edge_x - size / 2


func init_ingredients():
	for file in DirAccess.get_files_at("res://ingredients"):
		var ingredient: PackedScene = load("res://ingredients/" + file)
		var type: Ingredient.Type = ingredient.instantiate().type
		ingredient_types.append(type)
		ingredients_scene[type] = ingredient


func _ready():
	init_ingredients()
	next_recipe = create_recipe()
	update_recipe()
	on_lives_update.emit(lives)
	on_score_update.emit(score)


func _process(delta):
	var input : int = (int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left")))
	position.x += speed * delta * input
	position.x = clamp(position.x, min_x, max_x)


func create_recipe() -> Array[Ingredient.Type]:
	var _recipe: Array[Ingredient.Type] = []
	for i in range(3):
		var random_ingredient: Ingredient.Type = ingredient_types.pick_random()
		_recipe.append(random_ingredient)
	return _recipe


func update_recipe():
	recipe = next_recipe
	next_recipe = create_recipe()
	collected = [false, false, false]
	print("Recipe: ", recipe, " Next Recipe: ", next_recipe)

	on_recipe_update.emit(recipe, collected, next_recipe)

	
func collect_ingredient(type: Ingredient.Type):
	if not recipe:
		return
		
	for i in range(recipe.size()):
		if collected[i]:
			continue
		
		if type == recipe[i]:
			collected[i] = true
			check_potion()
			return
	
	lose_life()

func check_potion():
	for check in collected:
		if not check:
			on_recipe_update.emit(recipe, collected, next_recipe)
			return
	
	score += 1
	on_score_update.emit(score)
	update_recipe()
			
	
func lose_life():
	lives -= 1
	on_lives_update.emit(lives)
	if lives <= 0:
		game_over()

func game_over():
	on_game_over.emit(score)
	
func _on_cat_no_platform() -> void:
	game_over()
