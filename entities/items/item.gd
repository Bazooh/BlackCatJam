class_name Item extends Area2D


@export var gravity_scale: float = 1000.0

var is_dropping := false


func drop() -> void:
	is_dropping = true


func is_out_of_bounds() -> bool:
	return position.y > get_viewport_rect().size.y


func _process(delta) -> void:
	if is_dropping:
		position.y += gravity_scale * delta
	
	if is_out_of_bounds():
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	if not area is Cat or is_dropping:
		return

	drop()