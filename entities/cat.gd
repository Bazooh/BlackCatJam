class_name Cat extends Area2D


const PLATFORM_MARGIN = 16
const N_PLATFORMS = 3


var moving: bool = true
@export var speed: float = 50
@export var direction: int = 1
@export var platform_idx: int = 1

@onready var check_holes: Area2D = $CheckHoles


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
	var cat_rect: Rect2 = $CollisionShape.shape.get_rect()

	return \
		platform.global_position.x + platform_rect.position.x * abs(platform.scale.x) <= global_position.x + cat_rect.position.x * abs(scale.x) and \
		platform.global_position.x + platform_rect.end.x * abs(platform.scale.x) >= global_position.x + cat_rect.end.x * abs(scale.x)


func can_go_up() -> bool:
	if platform_idx >= N_PLATFORMS - 1:
		return false
	
	var areas: Array = $CheckHolesUp.get_overlapping_areas()
	for platform: Area2D in areas:
		if platform.is_in_group("Platform") and can_cat_be_on_platform(platform):
			return true

	return false


func can_go_down() -> bool:
	if platform_idx <= 0:
		return false
	
	var areas: Array = $CheckHolesDown.get_overlapping_areas()
	for platform: Area2D in areas:
		if platform.is_in_group("Platform") and can_cat_be_on_platform(platform):
			return true

	return false


func _physics_process(delta):
	if moving:
		position.x += speed * direction * delta
	
	if Input.is_action_just_pressed("up") and can_go_up():
		platform_idx += 1
		position.y -= PLATFORM_MARGIN
	elif Input.is_action_just_pressed("down") and can_go_down():
		platform_idx -= 1
		position.y += PLATFORM_MARGIN
	
	if not has_platform_below():
		change_direction()
