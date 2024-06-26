extends TextureRect

@onready var label: Label = $Label
@export var string: String = "Score: "
@export var digits: int = 1


func update_text(value: int):
	if not is_node_ready():
		await ready
		
	var number = "%0" + str(digits) + "d"
	var format_string = "%s%s"
	label.text = format_string % [string, number % value]


func _on_witch_on_score_update(score: int) -> void:
	update_text(score)
