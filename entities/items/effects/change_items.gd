class_name ChangeItemsEffect extends Effect


func _activate(_triggerer) -> void:
	var items_node = []
	var invalid_items = []
	
	for _item in Game.level_generator.items_node:
		if not is_instance_valid(_item) or _item == entity:
			invalid_items.append(_item)
			continue
			
		if _item.has_node("Effects/Drop"):
			var drop: Drop = _item.get_node("Effects/Drop")
			if drop.is_dropping:
				invalid_items.append(_item)
				continue
		items_node.append(_item)
	
	Game.level_generator.items_node = invalid_items
	

	for _item in items_node:
		if not is_instance_valid(_item) or _item == entity:
			continue

		var new_item: Item = Game.witch.get_usable_items().pick_random().instantiate()

		new_item.position = _item.position
		new_item.rotation = _item.rotation
		
		Game.level_generator.items_node.append(new_item)
		
		_item.get_parent().add_child.call_deferred(new_item)
		_item.queue_free()
	
	entity.queue_free()
