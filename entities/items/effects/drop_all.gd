class_name DropAllEffect extends Effect

@export var wait_time := 0.4

func _activate(_entity) -> void:
	
	await get_tree().create_timer(wait_time, false).timeout
	
	for item in Game.level_generator.items_node:
		if not is_instance_valid(item) or item == entity:
			continue
			
		if item.has_node("Effects/Drop") and item.item_name != "Pumpkin":
			var drop: Drop = item.get_node("Effects/Drop")
			if drop.is_dropping or not drop.enabled:
				continue
			
			if randf() >= 0.6:
				item.area_entered.emit(Game.cat)
