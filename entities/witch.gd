class_name Witch extends Area2D

var speed : float = 20

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input : int = (int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left")))
	position.x += speed * delta * input
