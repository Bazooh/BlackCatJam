class_name Witch extends Area2D

signal on_recipe_update(recipe, collected)
signal on_lives_update(lives)
signal on_game_over()

@export var speed : float = 100

@export var max_lives := 3
var ingredients_scene := {}
var ingredient_types : Array[Ingredient.Type]
var recipe : Array[Ingredient.Type] = []

var lives = 3
var collected : Array[bool] = []

const size : float = 30
const edge_x : float = 256

var min_x : float
var max_x : float


func init_ingredients():
	for file in DirAccess.get_files_at("res://ingredients"):
		var ingredient: PackedScene = load("res://ingredients/" + file)
		var type: Ingredient.Type = ingredient.instantiate().type
		ingredient_types.append(type)
		ingredients_scene[type] = ingredient
	
	print(ingredient_types)


func _ready():
	min_x = size / 2
	max_x = edge_x - size / 2
	
	init_ingredients()
	create_recipe()
	on_lives_update.emit(lives)

func _process(delta):
	var input : int = (int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left")))
	position.x += speed * delta * input
	position.x = clamp(position.x, min_x, max_x)

func create_recipe():
	recipe = []
	for i in range(3):
		var random_ingredient: Ingredient.Type = ingredient_types.pick_random()
		recipe.append(random_ingredient)
	collected = [false, false, false]
	on_recipe_update.emit(recipe, collected)
	
	
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
			on_recipe_update.emit(recipe, collected)
			return
		
	create_recipe()
			
	
func lose_life():
	lives -= 1
	on_lives_update.emit(lives)
	if lives <= 0:
		game_over()

func game_over():
	on_game_over.emit()
	
func _on_cat_no_platform() -> void:
	game_over()
