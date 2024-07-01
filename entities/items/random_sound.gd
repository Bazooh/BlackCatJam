class_name RandomSound extends AudioStreamPlayer

@export var sounds : Array[AudioStream] = []

func play_random_sound():
	stream = sounds.pick_random()
	play()
	
