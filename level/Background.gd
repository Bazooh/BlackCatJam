class_name Background extends Node2D

@export var decor_density: float = 0.9
@export var decor_folder: String = "ground"

var possible_decor: Array[PackedScene] = []
@export var decor_offset: float = 10.0
@export var floor_y: float = 140.0

@export var decor_gap: float = 30.0

var current_pos: float = 0.0
var chunk_length: float = 600.0

var spawn_x: float = 0.0


func _ready():
	var folder := "res://level/decor/" + decor_folder + "/"
	for file in DirAccess.get_files_at(folder):
		var decor: PackedScene = load(folder + file.trim_suffix(".remap"))
		possible_decor.append(decor)
	
	generate_decor(0.0)


func get_random_decor() -> PackedScene:
	return possible_decor.pick_random()


func _process(delta: float) -> void:
	current_pos -= delta * Game.level_generator.speed
	if current_pos <= -chunk_length / 2.0:
		generate_decor(chunk_length / 2.0)
		current_pos = chunk_length / 2.0


func generate_decor(x_pos: float):
	if not is_node_ready():
		await ready
		
	if possible_decor.size() == 0:
		return
	
	if decor_density == 0:
		return
	
	while spawn_x < chunk_length:
		if randf() < decor_density:
			var decor: Decor = get_random_decor().instantiate() as Decor
			add_child(decor)
			
			decor.global_position.x = x_pos + spawn_x
			decor.global_position.y = floor_y
			decor.z_index += self.z_index
			spawn_x += decor.get_sprite().get_rect().size.x 
			
		spawn_x += decor_gap + randf_range(0, 1) * decor_offset
	
	spawn_x -= chunk_length
