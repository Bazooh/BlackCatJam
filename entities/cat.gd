class_name Cat extends Entity

signal no_platform

const PLATFORM_MARGIN = 16

@onready var rect: Rect2 = $CollisionShape.shape.get_rect()


func can_cat_be_on_platform(platform: Area2D) -> bool:
	var platform_rect: Rect2 = platform.get_child(0).shape.get_rect()

	return \
		platform.global_position.x + platform_rect.position.x * abs(platform.scale.x) <= global_position.x + rect.position.x * abs(scale.x) and \
		platform.global_position.x + platform_rect.end.x * abs(platform.scale.x) >= global_position.x + rect.end.x * abs(scale.x)


func can_go_up() -> bool:
	var areas: Array = $CheckHolesUp.get_overlapping_areas()
	for platform: Area2D in areas:
		if platform.is_in_group("Platform") and can_cat_be_on_platform(platform):
			return true

	return false


func can_go_down() -> bool:
	var areas: Array = $CheckHolesDown.get_overlapping_areas()
	for platform: Area2D in areas:
		if platform.is_in_group("Platform") and can_cat_be_on_platform(platform):
			return true

	return false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("up") and can_go_up():
		position.y -= PLATFORM_MARGIN
	elif event.is_action_pressed("down") and can_go_down():
		position.y += PLATFORM_MARGIN



func _on_back_and_forth_effect_no_platform() -> void:
	no_platform.emit()
