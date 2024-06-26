class_name Decor extends Node2D

@onready var sprite: Sprite2D = $Sprite
@export var can_flip: bool = false

var speed : float

func _ready():
	if can_flip and randf() < 0.5:
		sprite.flip_h = true

func _process(delta):
	position.x -= speed * delta
	
	if global_position.x < -sprite.get_rect().size.x / 2:
		queue_free()
	
