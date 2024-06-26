class_name Item extends Area2D


@onready var cat_effects_node: Node = %CatEffects
@onready var witch_effects_node: Node = %WitchEffects


func get_cat_effects() -> Array:
	return cat_effects_node.get_children()


func activate_cat_effects() -> void:
	for effect: Effect in get_cat_effects():
		effect.activate()


func get_witch_effects() -> Array:
	return witch_effects_node.get_children()


func activate_witch_effects() -> void:
	for effect: Effect in get_witch_effects():
		effect.activate()


func get_effects() -> Array:
	return get_cat_effects() + get_witch_effects()


func is_out_of_bounds() -> bool:
	return position.y > get_viewport_rect().size.y


func _ready() -> void:
	for effect: Effect in get_effects():
		effect.item = self


func _process(_delta) -> void:
	if is_out_of_bounds():
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area is Cat:
		activate_cat_effects()
	
	elif area is Witch:
		activate_witch_effects()
		queue_free()