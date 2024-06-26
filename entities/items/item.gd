class_name Item extends Area2D


@onready 


func get_effects() -> Array:
	return 


func is_out_of_bounds() -> bool:
	return position.y > get_viewport_rect().size.y


func _process(delta) -> void:
	if is_dropping:
		position.y += gravity_scale * delta
	
	if is_out_of_bounds():
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	if not area is Cat:
		return

	