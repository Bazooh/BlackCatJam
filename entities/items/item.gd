class_name Item extends Entity

signal touch_cat(cat: Cat)
signal touch_witch(witch: Witch)
signal touch_ground()

const floor_offset := 5

@export var item_name: String
@export var difficulty: int = 0

@onready var sprite: Sprite2D = $Sprite
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer

@onready var touch_cat_sound: AudioStreamPlayer = $TouchCatSound
@onready var touch_witch_sound: AudioStreamPlayer = $TouchWitchSound
@onready var touch_ground_sound: AudioStreamPlayer = $TouchGroundSound
@onready var break_effect: AnimatedSprite2D = $BreakEffect

var enabled := true
var touched_ground := false

func is_out_of_bounds() -> bool:
	return position.y > get_viewport_rect().size.y - floor_offset


func _process(_delta) -> void:
	if not enabled or touched_ground:
		return
		
	if position.y >= Game.FLOOR_Y:
		touch_ground.emit()
		touched_ground = true
		if touch_ground_sound is RandomSound:
			touch_ground_sound.play_random_sound()
		elif touch_ground_sound.stream:
			touch_ground_sound.play()


func _on_area_entered(area: Area2D) -> void:
	if not enabled:
		return
		
	if area is Cat:
		touch_cat.emit(area as Cat)
		if touch_cat_sound is RandomSound:
			touch_cat_sound.play_random_sound()
		elif touch_cat_sound.stream:
			touch_cat_sound.play()
	
	elif area is Witch:
		touch_witch.emit(area as Witch)
		if touch_witch_sound is RandomSound:
			touch_witch_sound.play_random_sound()
		elif touch_witch_sound.stream:
			touch_witch_sound.play()


func destroy(play_effect:= false):
	sprite.hide()
	enabled = false
	
	if play_effect:
		break_effect.show()
		break_effect.reparent(Game, true)
		break_effect.global_position.y = Game.FLOOR_Y
		break_effect.rotation_degrees = 0
		break_effect.play("break")
		await break_effect.animation_finished
		break_effect.hide()
		break_effect.queue_free()
	
	if touch_cat_sound.playing:
		await touch_cat_sound.finished
	if touch_witch_sound.playing:
		await touch_witch_sound.finished
	if touch_ground_sound.playing:
		await touch_ground_sound.finished
	
	await get_tree().create_timer(2).timeout
	
	queue_free()
