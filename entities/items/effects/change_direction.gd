class_name ChangeDirectionEffect extends Effect


func _activate(cat) -> void:
	(cat.get_node("Effects/BackAndForthEffect") as BackAndForthEffect).change_direction()
	
