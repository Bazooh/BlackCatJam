class_name Witch extends Area2D

signal on_recipe_update(recipe: Array[Ingredient.Type], collected: Array[bool], next_recipe: Array[Ingredient.Type])
signal on_lives_update(lives: int)
signal on_score_update(score: int)
signal on_game_over(score: int)

@export var speed: float = 100.0

@export var max_lives: int = 3

@onready var difficulty_timer: Timer = %DifficultyTimer
var _difficulty: int = 0
var difficulty: float:
	get: return _difficulty + (0.0 if difficulty_timer.time_left == difficulty_timer.wait_time else difficulty_timer.time_left / difficulty_timer.wait_time)
	set(_x): push_warning("difficulty is read-only (use _difficulty instead)")

var ingredients_scene := {}
var ingredient_types: Array[Ingredient.Type]
var utility_items_scene: Array[PackedScene] = []
var recipe: Array[Ingredient.Type] = []
var next_recipe: Array[Ingredient.Type] = []

var lives: int = 3
var collected: Array[bool] = []

var score: int = 0

const size: float = 30.0
const edge_x: float = 256.0

const min_x: float = size / 2
const max_x: float = edge_x - size / 2


func init_items():
	for file in DirAccess.get_files_at("res://entities/items/ingredients"):
		var ingredient: PackedScene = load("res://entities/items/ingredients/" + file)
		var type: Ingredient.Type = ingredient.instantiate().type
		ingredient_types.append(type)
		ingredients_scene[type] = ingredient
	
	for file in DirAccess.get_files_at("res://entities/items/utility"):
		var item: PackedScene = load("res://entities/items/utility/" + file)
		utility_items_scene.append(item)


func get_usable_ingredients() -> Array[PackedScene]:
	var usable_ingredients: Array[PackedScene] = []
	for type in ingredient_types.slice(0, 3 + int(difficulty)):
		usable_ingredients.append(ingredients_scene[type])
	return usable_ingredients


func get_usable_items() -> Array[PackedScene]:
	return get_usable_ingredients() + utility_items_scene


func _ready():
	Game.witch = self
	init_items()
	next_recipe = create_recipe()
	update_recipe()
	on_lives_update.emit(lives)
	on_score_update.emit(score)


func _process(delta):
	position.x += speed * delta * Input.get_axis("left", "right")
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


func _on_difficulty_timer_timeout() -> void:
	_difficulty += 1
