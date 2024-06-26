class_name LevelGenerator extends Node2D


const platform_node = preload("res://level/Platform.tscn")
const directions = [Vector2i(0, 1), Vector2i(0, -1), Vector2i(1, 0), Vector2i(-1, 0)]

@export var platform_density: float = 0.4
@export var ingredient_density: float = 1.0
@export var chunk_length: int = 5
@export var n_chunks: int = 2
@export var height: int = 3
@export var speed: float = 20.0

@export var grid_y_offset: int = 32

@export var witch: Witch

@onready var grid: Array = init_grid()
@onready var platform_size: float = platform_node.instantiate().get_node("CollisionShape2D").shape.get_rect().size.x

var ingredient_nodes: Array = []
var platforms: Array = []


func init_grid() -> Array:
	var _grid := []
	for x in range(chunk_length * n_chunks):
		_grid.append([])
		for y in range(height):
			_grid[x].append(false)
	
	return _grid


func generate_platform(x_start: int, x_end: int, y: int) -> Node2D:
	var platform: Node2D = platform_node.instantiate()
	platform.position.x = (x_start + float(x_end - x_start) / 2) * platform_size
	platform.position.y = y * 16 + grid_y_offset
	platform.scale.x *= (x_end - x_start) + 1

	add_child(platform)
	return platform


func is_inside_chunk(chunk: Array, pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < chunk.size() and pos.y >= 0 and pos.y < chunk[0].size()


func have_path(chunk: Array, start: Vector2i, end: Vector2i) -> bool:
	if chunk.size() == 0:
		return false
	
	var queue := []
	var visited := {}
	
	queue.append(start)
	visited[start] = true
	
	while queue.size() > 0:
		var current = queue.pop_front()
		
		if current == end:
			return true
		
		for direction in directions:
			var neighbor = current + direction
			
			if is_inside_chunk(chunk, neighbor) and not visited.has(neighbor) and chunk[neighbor.x][neighbor.y]:
				queue.append(neighbor)
				visited[neighbor] = true
	
	return false


func generate_chunk_grid() -> Array:
	var chunk_grid := []
	
	while not have_path(chunk_grid, Vector2i(0, 1), Vector2i(chunk_length - 1, 1)):
		chunk_grid.clear()
		for x in range(chunk_length):
			chunk_grid.append([])
			for y in range(height):
				chunk_grid[x].append(randf() < platform_density)
		
		chunk_grid[0][1] = true
		chunk_grid[chunk_length - 1][1] = true
	
	return chunk_grid


func get_random_ingredient() -> Ingredient:
	for recipe_ingredient: Ingredient.Type in witch.recipe:
		var is_in_screen: bool = false
		for ingredient: Item in ingredient_nodes:
			if is_instance_valid(ingredient) and ingredient is Ingredient and ingredient.type == recipe_ingredient:
				is_in_screen = true
				break
		
		if not is_in_screen:
			return witch.ingredients_scene[recipe_ingredient].instantiate()
	
	return witch.ingredients_scene.values().pick_random().instantiate()


func generate_chunk(idx: int) -> void:
	var chunk_grid: Array = generate_chunk_grid()

	for x in range(chunk_length):
		for y in range(height):
			grid[idx*chunk_length + x][y] = chunk_grid[x][y]

			if chunk_grid[x][y] and randf() < ingredient_density:
				var ingredient = get_random_ingredient()
				ingredient.position = Vector2((idx*chunk_length + x) * platform_size, y * 16 + grid_y_offset)
				ingredient_nodes.append(ingredient)
				add_child(ingredient)


func move_grid() -> void:
	for y in range(height):
		for x in range(chunk_length * (n_chunks - 1)):
			grid[x][y] = grid[x + chunk_length][y]


func grid_to_node() -> void:
	for platform in platforms:
		platform.queue_free()
	platforms.clear()

	for y in range(height):
		var start: int = 0
		var last: bool = false
		for x in range(chunk_length * n_chunks):
			if grid[x][y] and not last:
				start = x
				last = true
			elif not grid[x][y] and last:
				platforms.append(generate_platform(start, x - 1, y))
				last = false
		if last:
			platforms.append(generate_platform(start, chunk_length * n_chunks - 1, y))


func _ready() -> void:
	for i in range(n_chunks):
		generate_chunk(i)
	grid_to_node()


func _physics_process(delta: float) -> void:
	position.x -= speed * delta

	if position.x < -chunk_length * platform_size:
		move_grid()

		for ingredient_node in ingredient_nodes.duplicate():
			if is_instance_valid(ingredient_node):
				ingredient_node.position.x -= chunk_length * platform_size
				if ingredient_node.position.x < -platform_size:
					ingredient_node.queue_free()

			if not is_instance_valid(ingredient_node):
				ingredient_nodes.erase(ingredient_nodes.find(ingredient_node))
		
		generate_chunk(n_chunks - 1)
		grid_to_node()
		position.x += chunk_length * platform_size

