class_name Drop extends Effect


@export var drop_speed: float = 1000.0

var is_dropping := false


func _activate() -> void:
	is_dropping = true


func _process(delta) -> void:
	if is_dropping:
		item.position.y += drop_speed * delta
	