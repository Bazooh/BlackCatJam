class_name ChangeRecipesEffect extends Effect


func _activate(_entity) -> void:
	var witch: Witch = Game.witch
	
	for i in range(witch.n_ingredients):
		if not witch.collected[i]:
			witch.recipe[i] = witch.usable_ingredients.pick_random().item_name
	
	witch.next_recipe = witch.create_recipe()

	witch.on_recipe_update.emit(witch.recipe, witch.collected, witch.next_recipe)
	
	(entity as Item).destroy()
	
