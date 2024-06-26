extends TextureRect

func open_game_over_screen():
	show()
	get_tree().paused = true

func restart():
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func return_to_menu():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui/menu.tscn")

func _on_restart_pressed() -> void:
	restart()

func _on_menu_pressed() -> void:
	return_to_menu()

func _on_witch_on_game_over() -> void:
	open_game_over_screen()
