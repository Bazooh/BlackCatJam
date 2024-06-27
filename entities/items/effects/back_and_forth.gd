class_name BackAndForthEffect extends Effect


signal no_platform


const size: float = 16
const edge_x: float = 256

const min_x: float = size / 2
const max_x: float = edge_x - size / 2


var is_moving: bool = false
@export var speed: float = 100.0
@export var direction: int = 1
@export var random_direction := false

var check_holes: Area2D


func _ready() -> void:
	super._ready()
	check_holes = entity.get_node("CheckHoles")


func change_direction():
	direction *= -1
	entity.scale.x = direction


func has_platform_below() -> bool:
	for area: Area2D in check_holes.get_overlapping_areas():
		if area.is_in_group("Platform"):
			return true
	return false


func is_hitting_edge() -> bool:
	return \
		(entity.global_position.x < min_x and direction == -1) or \
		(entity.global_position.x > max_x and direction == 1)


func _activate(_triggerer) -> void:
	await get_tree().create_timer(0.1).timeout

	is_moving = true
	if random_direction and randi() % 2 == 0:
		change_direction()


func _physics_process(delta: float) -> void:
	if is_moving:
		entity.position.x += speed * delta * direction

		if not has_platform_below() or is_hitting_edge():
			change_direction()

			await get_tree().create_timer(2 * delta).timeout
			if not has_platform_below():
				no_platform.emit()
				queue_free()


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not entity.has_node("CheckHoles"):
		warnings.append("CheckHoles (Area2D) node is missing in the entity.")
	return warnings