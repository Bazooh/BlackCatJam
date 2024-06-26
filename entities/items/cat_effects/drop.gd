class_name Drop extends Effect


@export var drop_speed: float = 300.0

const floor_y : int = 143

var is_dropping := false


func _activate(_cat) -> void:
	is_dropping = true


func _process(delta) -> void:
	if is_dropping:
		item.position.y += drop_speed * delta
		if item.position.y >= floor_y:
			item.destroy()
			is_dropping = false
	
