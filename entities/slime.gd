class_name Slime extends Entity


func _on_area_entered(area: Area2D) -> void:
	if not area is Witch:
		return

	area.speed /= 4.0


func _on_area_exited(area: Area2D) -> void:
	if not area is Witch:
		return

	area.speed *= 4.0


func _on_timer_timeout() -> void:
	queue_free()
