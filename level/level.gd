class_name Level extends Node2D

func _ready():
	Fade.fade_in()

	Game.camera = $Camera2D
	
