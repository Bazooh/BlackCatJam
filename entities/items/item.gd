class_name Item extends Entity


signal touch_cat(cat: Cat)
signal touch_witch(witch: Witch)
signal touch_ground()


@export var item_name: String
@export_range(0, 10) var difficulty: int = 0

@onready var animation_player: AnimationPlayer = %AnimationPlayer


func is_out_of_bounds() -> bool:
	return position.y > get_viewport_rect().size.y


func _process(_delta) -> void:
	if is_out_of_bounds():
		touch_ground.emit()


func _on_area_entered(area: Area2D) -> void:
	if area is Cat:
		touch_cat.emit(area as Cat)
	
	elif area is Witch:
		touch_witch.emit(area as Witch)


func destroy():
	queue_free()
