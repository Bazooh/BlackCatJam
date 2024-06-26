extends TextureRect

var paused := false

func _input(event: InputEvent):
	if Input.is_action_just_pressed("pause"):
		toggle_pause()

func toggle_pause():
	if not paused and get_tree().paused:
		return
	
	paused = !paused
	get_tree().paused = paused
	visible = paused

func return_to_menu():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui/menu.tscn")
	
	
func _on_resume_pressed() -> void:
	toggle_pause()

func _on_menu_pressed() -> void:
	return_to_menu()
