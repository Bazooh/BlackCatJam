extends AnimatedSprite2D

@onready var step: AudioStreamPlayer = $Step

func _ready():
	frame_changed.connect(_on_frame_changed)

func _on_frame_changed():
	match frame:
		4:
			step.play()
