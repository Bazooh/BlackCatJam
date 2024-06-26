class_name Cat extends Area2D

var moving : bool = true
var speed : float = 10
var direction : int = 1


func _process(delta):
	if moving:
		position.x += speed * direction * delta
		

func change_direction():
	direction *= -1
