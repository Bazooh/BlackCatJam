class_name Drop extends Effect


@export var speed := Vector2(0.0, 0.0)
@export var gravity: float = 500.0

# const floor_y: int = 143

var is_dropping := false


func _ready() -> void:
	super._ready()
	entity.touch_ground.connect(entity.destroy)


func _activate(_cat) -> void:
	is_dropping = true


func _process(delta) -> void:
	if is_dropping:
		speed += Vector2(0.0, gravity * delta)
		entity.position += speed * delta
	
