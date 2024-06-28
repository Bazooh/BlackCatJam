class_name DuplicateCatEffect extends Effect


@export var duration: float = 5.0


func _activate(cat) -> void:
	var new_cat: Cat = cat.duplicate()

	new_cat.get_node("Effects/BackAndForthEffect").change_direction()
	get_tree().create_timer(duration).timeout.connect(func(): new_cat.destroy())

	cat.get_parent().add_child(new_cat)
	