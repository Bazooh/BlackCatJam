extends Node

@onready var sound: AudioStreamPlayer = $Sound

func play_sound():
	sound.play()
