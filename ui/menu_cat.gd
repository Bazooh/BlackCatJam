class_name MenuCat extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var speed: float = 100.0

var is_moving := false

func start():
	sprite.animation = "start"

func run():
	sprite.play("run")
	is_moving = true
	
	
func _process(delta):
	if is_moving:
		position.x += speed * delta
