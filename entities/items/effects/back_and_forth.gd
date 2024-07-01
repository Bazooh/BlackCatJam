class_name BackAndForthEffect extends Effect

signal turn
signal no_platform


const size: float = 16
const edge_x: float = 256

const min_x: float = size / 2
const max_x: float = edge_x - size / 2


var is_moving: bool = false
@export var speed: float = 100.0
@export var random_direction := false

@export var hit_left_wall: bool = true

var check_holes: Area2D
var check_holes_behind: Area2D

var drop: Drop = null


func _ready() -> void:
	super._ready()
	check_holes = entity.get_node("CheckHoles")
	check_holes_behind = entity.get_node("CheckHolesBehind")

	if entity.has_node("Effects/Drop"):
		drop = entity.get_node("Effects/Drop")


func change_direction():
	entity.scale.x = -entity.scale.x
	
	turn.emit()


func has_platform_behind() -> bool:
	return check_holes_behind.get_overlapping_areas().any(func(area: Area2D): return area.is_in_group("Platform"))


func has_platform_below() -> bool:
	return check_holes.get_overlapping_areas().any(func(area: Area2D): return area.is_in_group("Platform"))


func is_hitting_edge() -> bool:
	return \
		(hit_left_wall and entity.global_position.x < min_x and entity.scale.x < 0) or \
		(entity.global_position.x > max_x and entity.scale.x > 0)


func _activate(_triggerer) -> void:
	await get_tree().create_timer(0.1).timeout

	is_moving = true
	if random_direction and randi() % 2 == 0:
		change_direction()


func _physics_process(delta: float) -> void:
	if not Game.level_generator:
		return
	
	if not Game.level_generator.is_node_ready:
		await Game.level_generator.ready
	
	if drop != null and drop.is_dropping:
		return
	
	if not hit_left_wall and entity.global_position.x < min_x:
		entity.queue_free()
	
	if is_moving:
		entity.position.x += speed * delta * sign(entity.scale.x)

		if not has_platform_below() or is_hitting_edge():
			change_direction()

			if not has_platform_behind():
				print("signal no platform")
				no_platform.emit()
