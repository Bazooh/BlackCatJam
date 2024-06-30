class_name Cat extends Entity

signal no_platform

const PLATFORM_MARGIN = 16

@export var tween_time := 0.1

@onready var rect: Rect2 = $CollisionShape.shape.get_rect()
@onready var jump_sound: AudioStreamPlayer = $JumpSound
@onready var turn_sound: AudioStreamPlayer = $TurnSound

@onready var sprite: AnimatedSprite2D = $Sprite

var tween

func _ready() -> void:
	if Game.cat == null:
		Game.cat = self


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
	if tween:
		return
		
	if event.is_action_pressed("up") and can_go_up():
		move_platforms(-1)
	elif event.is_action_pressed("down") and can_go_down():
		move_platforms(1)
		

func move_platforms(direction: int):
	position.y += PLATFORM_MARGIN * sign(direction)
	sprite.position.y -= PLATFORM_MARGIN * sign(direction)

	sprite.play("up" if direction < 0 else "down")
	
	jump_sound.play()
	tween = create_tween()
	tween.tween_property(sprite, "global_position:y", global_position.y, tween_time)
	tween.tween_callback(tween_finished)


func tween_finished():
	sprite.position = Vector2.ZERO
	tween = null
	sprite.play("run")


func _on_back_and_forth_effect_no_platform() -> void:
	print("no platform!")
	no_platform.emit()


func _on_back_and_forth_effect_turn() -> void:
	if not turn_sound.playing:
		turn_sound.play()

