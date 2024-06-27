class_name Witch extends Area2D

signal on_recipe_update(recipe: Array[Ingredient], collected: Array[bool], next_recipe: Array[Ingredient])
signal on_lives_update(lives: int)
signal on_score_update(score: int)
signal on_game_over(score: int)

@export var speed: float = 100.0

@export var max_lives: int = 3

@onready var difficulty_timer: Timer = %DifficultyTimer
var _difficulty: int = 0
var difficulty: float:
	get: return _difficulty + (difficulty_timer.wait_time - difficulty_timer.time_left) / difficulty_timer.wait_time
	set(_x): push_warning("difficulty is read-only (use _difficulty instead)")

var name_to_item := {}

var ingredients: Array[Ingredient]
var usable_ingredients: Array[Ingredient]

var utility_items: Array[Item] = []
var usable_utility_items: Array[Item]

var recipe: Array[String] = []
var next_recipe: Array[String] = []

var lives: int = 3
var collected: Array[bool] = []

var score: int = 0

const size: float = 30.0
const edge_x: float = 256.0

const min_x: float = size / 2
const max_x: float = edge_x - size / 2


func init_items():
	for file in DirAccess.get_files_at("res://entities/items/ingredients"):
		var ingredient_scene: PackedScene = load("res://entities/items/ingredients/" + file)
		var ingredient: Ingredient = ingredient_scene.instantiate()
		ingredients.append(ingredient)
		name_to_item[ingredient.item_name] = ingredient
	
	for file in DirAccess.get_files_at("res://entities/items/utility"):
		var item_scene: PackedScene = load("res://entities/items/utility/" + file)
		var item: Item = item_scene.instantiate()
		utility_items.append(item)
		name_to_item[item.item_name] = item
	
	update_usable_ingredients()
	update_utility_items()


func get_item_based_on_difficulty(_ingredients: Array) -> Item:
	var probabilities: Array = []
	for ingredient: Item in _ingredients:
		probabilities.append(exp(abs(difficulty - ingredient.difficulty)))
	
	var sum: float = probabilities.reduce(func(acc, x): return acc + x)
	probabilities = probabilities.map(func(x): return x / sum)

	var random: float = randf()
	var idx: int = 0
	while random > probabilities[idx]:
		random -= probabilities[idx]
		idx += 1
	
	return _ingredients[idx]


func update_usable_ingredients() -> void:
	usable_ingredients.clear()

	var temp_ingredients: Array[Ingredient] = ingredients.duplicate()
	for i in range(3):
		var ingredient: Ingredient = get_item_based_on_difficulty(temp_ingredients)
		usable_ingredients.append(ingredient)
		temp_ingredients.erase(ingredient)


func update_utility_items() -> void:
	usable_utility_items.clear()
	
	var items: Array[Item] = utility_items.duplicate()
	for i in range(2):
		var item: Item = get_item_based_on_difficulty(items)
		usable_utility_items.append(item)
		items.erase(item)


func get_usable_items() -> Array:
	return usable_ingredients + usable_utility_items


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


func create_recipe() -> Array[String]:
	var _recipe: Array[String] = []
	for i in range(3):
		var random_ingredient: String = ingredients.pick_random().item_name
		_recipe.append(random_ingredient)
	return _recipe


func update_recipe():
	recipe = next_recipe
	next_recipe = create_recipe()
	collected = [false, false, false]
	on_recipe_update.emit(recipe, collected, next_recipe)

	
func collect_ingredient(ingredient_name: String) -> void:
	if not recipe:
		return
		
	for i in range(recipe.size()):
		if collected[i]:
			continue
		
		if ingredient_name == recipe[i]:
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
	update_usable_ingredients()
	update_utility_items()
