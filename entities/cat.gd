class_name Cat extends Area2D


const PLATFORM_MARGIN = 16


var moving: bool = true
@export var speed: float = 50
@export var direction: int = 1

@onready var check_holes: Area2D = $CheckHoles
@onready var rect: Rect2 = $CollisionShape.shape.get_rect()


func change_direction():
	direction *= -1
	scale.x = direction


func has_platform_below() -> bool:
	for area: Area2D in check_holes.get_overlapping_areas():
		if area.is_in_group("Platform"):
			return true
	return false


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


func _physics_process(delta):
	if moving:
		position.x += speed * direction * delta
	
	if Input.is_action_just_pressed("up") and can_go_up():
		position.y -= PLATFORM_MARGIN
	elif Input.is_action_just_pressed("down") and can_go_down():
		position.y += PLATFORM_MARGIN
	
	if not has_platform_below() or check_holes.global_position.x < 0 or check_holes.global_position.x > get_viewport_rect().size.x:
		change_direction()
