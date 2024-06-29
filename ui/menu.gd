extends Control

const LEVEL = preload("res://level/level.tscn")

func start():
	get_tree().change_scene_to_packed(LEVEL)


func _on_button_pressed() -> void:
	ButtonSound.play_sound()
	start()
