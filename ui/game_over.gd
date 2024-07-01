extends TextureRect


@onready var scores: Label = $Scores
@onready var new_high: Label = $NewHigh

func open_game_over_screen(score: int) -> void:
	show()
	
	var data := SaveData.load_or_create()
	
	if score > data.high_score:
		data.high_score = score
		data.save()
		new_high.show()
	
	var number = "%03d"
	var format_string = "Score: %s\nHigh: %s"
	scores.text = format_string % [number % score, number % data.high_score]
	
	get_tree().paused = true


func restart() -> void:
	ButtonSound.play_sound()
	get_tree().paused = false
	get_tree().reload_current_scene()


func return_to_menu() -> void:
	ButtonSound.play_sound()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui/menu.tscn")


func _on_restart_pressed() -> void:
	restart()


func _on_menu_pressed() -> void:
	return_to_menu()


func _on_witch_on_game_over(score: int) -> void:
	open_game_over_screen(score)


func _on_scoreboard_pressed() -> void:
	ButtonSound.play_sound()
	Leaderboard.show(self)
