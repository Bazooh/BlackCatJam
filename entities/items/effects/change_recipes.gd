class_name ChangeRecipesEffect extends Effect


func _activate(_entity) -> void:
	var witch: Witch = Game.witch

	var guaranteed : Array[String] = []
	
	for item in Game.level_generator.items_node:
		if not is_instance_valid(item) or item == entity or not item is Ingredient:
			continue
		
		if item.has_node("Effects/Drop") :
			var drop: Drop = item.get_node("Effects/Drop")
			if drop.is_dropping and witch.recipe.has(item.item_name) and not guaranteed.has(item.item_name):
					guaranteed.append(item.item_name)
	
	for i in range(witch.n_ingredients):
		if not witch.collected[i]:
			var next_item: String
			if guaranteed.size() > 0:
				next_item = guaranteed.pop_front()
			else:
				next_item = witch.usable_ingredients.pick_random().item_name
			witch.recipe[i] = next_item
	
	witch.on_recipe_update.emit(witch.recipe, witch.collected, witch.next_recipe)
	
	(entity as Item).destroy()
	
