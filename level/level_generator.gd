class_name LevelGenerator extends Node2D


const platform_node = preload("res://level/Platform.tscn")
const directions = [Vector2i(0, 1), Vector2i(0, -1), Vector2i(1, 0), Vector2i(-1, 0)]

const item_y_offset = -8

@export_group("Intro Settings")
@export var intro_platform_density: float = 1
@export var intro_item_density: float = 0
@export var intro_length: int = 1

@export_group("Main Settings")
@export var platform_density: float = 0.4
@export var item_density: float = 1.0
@export var chunk_length: int = 1
@export var n_chunks: int = 6
@export var start_height: int = 3
@export var max_height: int = 4
var height: int:
	get: return min(start_height + floori(float(witch.difficulty) / 8), max_height)
	set(_x): push_warning("height is read-only")

@export var start_speed: float = 20.0
@export var speed_increase_per_difficulty: float = 5.0
var speed: float:
	get: return start_speed + speed_increase_per_difficulty * witch.difficulty
	set(_x): push_warning("speed is read-only")

@export var item_offset: float = 20

@export var grid_y_offset: int = 32

@export var witch: Witch

var chunk_path_end_height: Array[int] = []

@onready var grid: Array = init_grid()
@onready var platform_size: float = platform_node.instantiate().get_node("CollisionShape2D").shape.get_rect().size.x

var items_node: Array = []
var platforms: Array = []

var chunk_number: int = 0

			
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


func have_path(chunk: Array, start: Vector2i, end_height_wanted: int) -> bool:
	if chunk.size() == 0:
		return false
	
	var queue := []
	var visited := {}
	
	queue.append(start)
	visited[start] = true
	
	while queue.size() > 0:
		var current = queue.pop_front()
		
		if current.x == chunk.size() - 1 and current.y == end_height_wanted:
			return true
		
		for direction in directions:
			var neighbor = current + direction
			
			if is_inside_chunk(chunk, neighbor) and not visited.has(neighbor) and chunk[neighbor.x][neighbor.y]:
				queue.append(neighbor)
				visited[neighbor] = true
	
	return false


func generate_chunk_grid(path_start_height: int) -> Array:
	var chunk_grid := []
	var path_end_height_wanted: int = randi_range(0, height - 1)
	
	while not have_path(chunk_grid, Vector2i(0, path_start_height), path_end_height_wanted):
		chunk_grid.clear()
		for x in range(chunk_length):
			chunk_grid.append([])
			for y in range(height):
				chunk_grid[x].append(randf() < get_platform_density())
		
		chunk_grid[0][path_start_height] = true
	
	chunk_path_end_height.append(path_end_height_wanted)
	
	return chunk_grid


func get_random_item() -> Item:
	for ingredient_name: String in witch.recipe:
		var is_in_screen: bool = false
		for item in items_node:
			if is_instance_valid(item) and item is Ingredient and item.item_name == ingredient_name:
				is_in_screen = true
				break
		
		if not is_in_screen:
			return witch.name_to_item[ingredient_name].duplicate()
	
	return witch.get_random_usable_item_weighted().duplicate()


func generate_chunk(idx: int) -> void:
	var chunk_grid: Array = generate_chunk_grid(1 if idx == 0 else chunk_path_end_height[idx - 1])

	if idx != 0:
		for y in range(height):
			if grid[idx * chunk_length - 1][y] and not chunk_grid[0][y] and (y == 0 or not grid[idx * chunk_length - 1][y - 1]) and (y == height - 1 or not grid[idx * chunk_length - 1][y + 1]):
				chunk_grid[0][y] = true

	for y in range(height):
		for x in range(chunk_length - 1):
			if chunk_grid[x][y] and not chunk_grid[x + 1][y] and (y == 0 or not chunk_grid[x][y - 1]) and (y == height - 1 or not chunk_grid[x][y + 1]):
				chunk_grid[x + 1][y] = true
	
	for x in range(chunk_length):
		for y in range(height):
			grid[idx*chunk_length + x][y] = chunk_grid[x][y]

			if chunk_grid[x][y] and randf() < get_item_density():
				var item: Item = get_random_item()
				item.position = Vector2((idx*chunk_length + x) * platform_size, y * 16 + grid_y_offset + item_y_offset)
				item.position.x += randf_range(-1, 1) * item_offset
				items_node.append(item)
				add_child(item)
	
	chunk_number += 1
	

func move_grid() -> void:
	if grid[0].size() < height:
		for x in range(chunk_length * n_chunks):
			grid[x].append(false)

	for y in range(height):
		for x in range(chunk_length * (n_chunks - 1)):
			grid[x][y] = grid[x + chunk_length][y]

	chunk_path_end_height.remove_at(0)


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
	Game.level_generator = self

	for i in range(n_chunks):
		generate_chunk(i)
	grid_to_node()
	
	
func _physics_process(delta: float) -> void:
	position.x -= speed * delta

	if position.x < -chunk_length * platform_size:
		move_grid()

		for item_node in items_node.duplicate():
			if is_instance_valid(item_node):
				item_node.position.x -= chunk_length * platform_size
				if item_node.position.x < -platform_size:
					item_node.queue_free()

			if not is_instance_valid(item_node):
				items_node.erase(items_node.find(item_node))
		
		generate_chunk(n_chunks - 1)
		grid_to_node()
		position.x += chunk_length * platform_size


func get_platform_density() -> float:
	if chunk_number < intro_length:
		return intro_platform_density
	return platform_density


func get_item_density() -> float:
	if chunk_number < intro_length:
		return intro_item_density
	return item_density
