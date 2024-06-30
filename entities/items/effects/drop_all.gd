class_name DropAllEffect extends Effect


func _activate(_entity) -> void:
	for item in Game.level_generator.items_node:
		if not is_instance_valid(item) or item == entity:
			continue
			
		if item.has_node("Effects/Drop"):
			var drop: Drop = item.get_node("Effects/Drop")
			if (not drop.enabled) or drop.is_dropping:
				continue
			if randf() > 0.5:
				item.area_entered.emit(Game.cat)
		
		
		
