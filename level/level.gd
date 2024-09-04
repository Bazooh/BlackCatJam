class_name Level extends Node2D


func _ready() -> void:
	Game.level = self
	Fade.fade_in()

	Game.camera = $Camera2D