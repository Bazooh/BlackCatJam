class_name DuplicateCatEffect extends Effect


@export var duration: float = 5.0
@export var new_cat_transparency: float = 0.6


func _activate(cat) -> void:
	var new_cat: Cat = cat.duplicate()

	get_tree().create_timer(duration).timeout.connect(func(): if is_instance_valid(new_cat): new_cat.queue_free())
	new_cat.modulate.a = new_cat_transparency

	cat.get_parent().add_child.call_deferred(new_cat)

	await new_cat.ready

	new_cat.global_position = cat.global_position
	new_cat.get_node("Sprite").position = Vector2.ZERO
	new_cat.get_node("Effects/BackAndForthEffect").change_direction()
	
