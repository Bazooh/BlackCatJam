class_name BombEffect extends Effect


enum Target { Cat, Witch }


const bomb_scene = preload("res://entities/bomb.tscn")

@export var target := Target.Witch


func _activate(_triggerer) -> void:
	var bomb: Bomb = bomb_scene.instantiate()
	Game.level.add_child(bomb)
	bomb.global_position = entity.global_position

	bomb.explode([target])
