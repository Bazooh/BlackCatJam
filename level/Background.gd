extends Node2D

@export var decor_density = 0.9

var possible_decor : Array[PackedScene] = []
@export var decor_offset : float = 10
@export var floor_y = 140

@export var decor_gap = 30


func _ready():
	for file in DirAccess.get_files_at("res://level/decor/"):
		var decor: PackedScene = load("res://level/decor/" + file)
		possible_decor.append(decor)

func get_random_decor() -> PackedScene:
	return possible_decor.pick_random()

func generate_decor(x_pos: float, level_generator: LevelGenerator):
	if not is_node_ready():
		await ready
		
	if possible_decor.size() == 0:
		return
	
	
	if decor_density == 0:
		return
		
	var current_x : float = 0
	
	while current_x < level_generator.chunk_length * level_generator.platform_size:
		if randf() < decor_density:
			var decor : Decor = get_random_decor().instantiate() as Decor
			decor.position.x = x_pos + current_x
			decor.position.y = floor_y
			decor.speed = level_generator.speed
			get_tree().root.add_child(decor)
			current_x += decor.sprite.get_rect().size.x 
		current_x += decor_gap + randf_range(0, 1) * decor_offset
