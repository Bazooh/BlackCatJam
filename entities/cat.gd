class_name Cat extends Area2D


const PLATFORM_MARGIN = 16
const N_PLATFORMS = 3


var moving: bool = true
var jump := false
@export var speed: float = 50
@export var direction: int = 1
@export var platform: int = 1

@onready var check_holes: Area2D = $CheckHoles


func change_direction():
	direction *= -1
	scale.x = direction


func has_platform_below() -> bool:
	for area: Area2D in check_holes.get_overlapping_areas():
		if area.is_in_group("Platform"):
			return true
	return false


func _physics_process(delta):
	if moving:
		position.x += speed * direction * delta
	
	if Input.is_action_just_pressed("up") and platform < N_PLATFORMS - 1:
		platform += 1
		position.y -= PLATFORM_MARGIN
		jump = true
	elif Input.is_action_just_pressed("down") and platform > 0:
		platform -= 1
		position.y += PLATFORM_MARGIN
		jump = true
	
	if not has_platform_below():
		change_direction()
