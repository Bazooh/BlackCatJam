class_name DropAllEffect extends Effect


func _activate(cat) -> void:
	for item: Item in Game.level_generator.items_node:
		if not is_instance_valid(item) or item == entity:
			continue
		
		item.area_entered.emit(cat)
