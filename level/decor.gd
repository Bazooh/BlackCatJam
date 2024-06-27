class_name Decor extends Node2D

@export var can_flip: bool = false

func _ready():
	if can_flip and randf() < 0.5:
		get_sprite().flip_h = true

func _physics_process(delta: float):
	if not is_instance_valid(Game.level_generator):
		queue_free()
		return

	position.x -= Game.level_generator.speed * delta
	
	if global_position.x < -(get_sprite().get_rect().size.x / 2):
		queue_free()

func get_sprite() -> Sprite2D:
	return $Sprite

