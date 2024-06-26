class_name Witch extends Area2D

@export var speed : float = 100
@export var recipe : Array[Ingredient.IngredientType] = []

var next_ingredient = 0

const size : float = 30
const edge_x : float = 256

var min_x : float
var max_x : float

func _ready():
	min_x = size / 2
	max_x = edge_x - size / 2


func _process(delta):
	var input : int = (int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left")))
	position.x += speed * delta * input
	position.x = clamp(position.x, min_x, max_x)
	
func collect_ingredient(type: Ingredient.IngredientType):
	if not recipe:
		return
	
	if recipe.size() <= next_ingredient:
		return
		
	if type == recipe[next_ingredient]:
		next_ingredient += 1
		if next_ingredient == recipe.size():
			print("Win :D")
		else:
			print("Correct :)")
	else:
		print("Incorrect :(")
