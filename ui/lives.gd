extends HBoxContainer

var hearts: Array[TextureRect] = []

func _ready():
	for child in get_children():
		if child is TextureRect:
			hearts.append(child as TextureRect)

func update_lives(lives: int):
	if not is_node_ready():
		await ready
	
	for i in range(hearts.size()):
		var tex = hearts[i].texture as AtlasTexture
		if lives > i:
			tex.region.position.x = 0
		else:
			tex.region.position.x = tex.region.size.x


func _on_witch_on_lives_update(lives: int):
	update_lives(lives)
