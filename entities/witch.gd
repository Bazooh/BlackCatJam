class_name Witch extends Area2D


signal on_recipe_update(recipe: Array[Ingredient], collected: Array[bool], next_recipe: Array[Ingredient])
signal on_lives_update(lives: int)
signal on_score_update(score: int)
signal on_game_over(score: int)


const n_ingredients: int = 3


@export var speed: float = 100.0
@export var stuck_speed: float = 25.0

@export var max_lives: int = 3

@export_group("Difficulty")	
@export var starting_ingredient_pool_size := 3
@export var ingredient_pool_increase_interval := 8
@export var ingredient_pool_increase_offset := 6
@export var ingredient_swap_rate := 1
@export var starting_utility_pool_size := 0
@export var utility_pool_increase_interval := 7
@export var utility_swap_rate := 2
@export var utility_pool_increase_offset := 3
@export var utility_chance := 0.33

@onready var sprite: AnimatedSprite2D = %Sprite
@onready var effect_sprite: AnimatedSprite2D = %EffectSprite

@onready var correct_sound: AudioStreamPlayer = $CorrectSound
@onready var wrong_sound: AudioStreamPlayer = $WrongSound
@onready var complete_sound: AudioStreamPlayer = $CompleteSound
@onready var hurt_sound: AudioStreamPlayer = $HurtSound
@onready var lose_sound: AudioStreamPlayer = $LoseSound


var difficulty: int = 0
#var difficulty: float:
	#get: return _difficulty + (difficulty_timer.wait_time - difficulty_timer.time_left) / difficulty_timer.wait_time
	#set(_x): push_warning("difficulty is read-only (use _difficulty instead)")

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

var ingredient_pool_size := 0
var utility_pool_size := 0

var stuck := false

func init_items():
	
	var to_shuffle: Array[Item] = []
	
	for file in DirAccess.get_files_at("res://entities/items/ingredients"):
		var ingredient_scene: PackedScene = load("res://entities/items/ingredients/" + file.trim_suffix('.remap'))
		var ingredient: Ingredient = ingredient_scene.instantiate()
		ingredients.append(ingredient)
		if ingredient.shuffle_difficulty:
			to_shuffle.append(ingredient)
		name_to_item[ingredient.item_name] = ingredient
	
	#shuffle difficulties
	var possible_difficulties : Array[int] = []
	for item in to_shuffle:
		possible_difficulties.append(item.difficulty)
	
	for item in to_shuffle:
		var _difficulty : int = possible_difficulties.pick_random()
		item.difficulty = _difficulty
		possible_difficulties.erase(_difficulty)
		
	
	for file in DirAccess.get_files_at("res://entities/items/utility"):
		var item_scene: PackedScene = load("res://entities/items/utility/" + file.trim_suffix('.remap'))
		var item: Item = item_scene.instantiate()
		utility_items.append(item)
		name_to_item[item.item_name] = item
	
	for i in range(starting_ingredient_pool_size):
		add_usable_ingredient()
	
	for i in range(starting_utility_pool_size):
		add_usable_utility()


func get_item_based_on_difficulty(_ingredients: Array) -> Item:
	var possible_items: Array = []
	for item: Item in _ingredients:
		if difficulty >= item.difficulty:
			possible_items.append(item)
	if possible_items.size() == 0:
		return null
	return possible_items.pick_random()
		
	#var probabilities: Array = []
	#for ingredient: Item in _ingredients:
		#probabilities.append(exp(abs(difficulty - ingredient.difficulty)))
	#
	#var sum: float = probabilities.reduce(func(acc, x): return acc + x)
	#probabilities = probabilities.map(func(x): return x / sum)
#
	#var random: float = randf()
	#var idx: int = 0
	#while random > probabilities[idx]:
		#random -= probabilities[idx]
		#idx += 1
	#
	#return _ingredients[idx]


func add_usable_ingredient():
	var item : Ingredient = random_unused_ingredient()
	if item:
		usable_ingredients.append(item)
		ingredient_pool_size += 1


func add_usable_utility():
	var item : Item = random_unused_utility()
	if item:
		usable_utility_items.append(item)
		utility_pool_size += 1


func swap_usable_ingredient() -> void:
	if usable_ingredients.size() == 0:
		return
	var swap_index : int = randi_range(0, usable_ingredients.size() - 1)
	var item : Ingredient = random_unused_ingredient()
	if item:
		usable_ingredients[swap_index] = item


func swap_utility_item() -> void:
	if usable_utility_items.size() == 0:
		return
	var swap_index : int = randi_range(0, usable_utility_items.size() - 1)
	var item : Item = random_unused_utility()
	if item:
		usable_utility_items[swap_index] = item


func random_unused_ingredient() -> Ingredient:
	var possible : Array = get_unused_items(usable_ingredients, ingredients)
	if possible.size() == 0:
		return null
	return get_item_based_on_difficulty(possible)


func random_unused_utility() -> Item:
	var possible : Array = get_unused_items(usable_utility_items, utility_items)
	if possible.size() == 0:
		return null
	return get_item_based_on_difficulty(possible)


func get_unused_items(usable: Array, all: Array) -> Array:
	var unused : Array = []
	for item in all:
		if not usable.has(item):
			unused.append(item)
	return unused


#higher chance of returning ingredient
func get_random_usable_item_weighted() -> Item:
	var _usable_ingredients: Array[Ingredient] = usable_ingredients.duplicate()
	var ingredients_name: Array = _usable_ingredients.map(func(x: Ingredient): return x.item_name)

	for ingredient_name: String in recipe:
		if not ingredients_name.has(ingredient_name):
			_usable_ingredients.append(name_to_item[ingredient_name])

	if randf() >= utility_chance or usable_utility_items.size() == 0:
		return _usable_ingredients.pick_random()
	else:
		return usable_utility_items.pick_random()
	

func set_stuck(value: bool) -> void:
	stuck = value
	sprite.animation = "Stuck" if stuck else "Move"
	
func _ready():
	Game.witch = self
	init_items()
	next_recipe = create_recipe()
	update_recipe()
	on_lives_update.emit(lives)
	on_score_update.emit(score)


func _process(delta: float) -> void:
	var move_speed := stuck_speed if stuck else speed
	position.x += move_speed * delta * Input.get_axis("left", "right")
	position.x = clamp(position.x, min_x, max_x)


func create_recipe() -> Array[String]:
	var _recipe: Array[String] = []
	for i in range(n_ingredients):
		var random_ingredient: String = usable_ingredients.pick_random().item_name
		_recipe.append(random_ingredient)
	return _recipe


func update_recipe() -> void:
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
			effect_sprite.stop()
			effect_sprite.animation = "Splash"
			effect_sprite.play()
			correct_sound.play()
			check_potion()
			return
	
	effect_sprite.stop()
	effect_sprite.animation = "Smoke"
	effect_sprite.play()
	wrong_sound.play()
	lose_life()


func check_potion() -> void:
	for check in collected:
		if not check:
			on_recipe_update.emit(recipe, collected, next_recipe)
			return
	
	score += 1
	complete_sound.play()
	on_score_update.emit(score)
	increase_difficulty()
	update_recipe()


func lose_life() -> void:
	lives -= 1
	on_lives_update.emit(lives)
	hurt_sound.play()
	if lives <= 0:
		game_over()


func game_over() -> void:

	lose_sound.play()
	on_game_over.emit(score)


func _on_cat_no_platform() -> void:
	game_over()


func increase_difficulty() -> void:
	difficulty += 1
	
	if get_ingredient_pool_size() > ingredient_pool_size:
		add_usable_ingredient()
	elif difficulty % ingredient_swap_rate == 0:
		swap_usable_ingredient()
	
	if get_utility_pool_size() > utility_pool_size:
		add_usable_utility()
	elif difficulty % utility_swap_rate == 0:
		swap_utility_item()


func get_ingredient_pool_size() -> int:
	return min(ingredients.size(), starting_ingredient_pool_size + floor(float(difficulty + ingredient_pool_increase_offset) / ingredient_pool_increase_interval))


func get_utility_pool_size() -> int:
	return min(utility_items.size(), starting_utility_pool_size + floor(float(difficulty + utility_pool_increase_offset) / utility_pool_increase_interval))
