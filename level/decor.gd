class_name Decor extends Node2D

@onready var sprite: Sprite2D = $Sprite
@export var can_flip: bool = false

var level_generator: LevelGenerator

func _ready():
	if can_flip and randf() < 0.5:
		sprite.flip_h = true

func _process(delta):
	if not is_instance_valid(level_generator):
		queue_free()
		return

	position.x -= level_generator.speed * delta
	
	if global_position.x < -sprite.get_rect().size.x / 2:
		queue_free()
	
