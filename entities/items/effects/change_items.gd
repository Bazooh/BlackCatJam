class_name ChangeItemsEffect extends Effect


func _activate(_entity) -> void:
	var items_node = Game.level_generator.items_node.duplicate()
	Game.level_generator.items_node.clear()

	for _item in items_node:
		if not is_instance_valid(_item):
			continue

		var new_item: Item = Game.witch.get_usable_items().pick_random().instantiate()

		new_item.position = _item.position
		new_item.rotation = _item.rotation
		new_item.scale = _item.scale

		if _item.has_node("Effects/Drop") and new_item.has_node("Effects/Drop") and _item.get_node("Effects/Drop").is_dropping:
			new_item.get_node("Effects/Drop").is_dropping = true
		
		Game.level_generator.items_node.append(new_item)
		
		_item.get_parent().add_child(new_item)
		_item.queue_free()