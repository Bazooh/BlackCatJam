class_name Bomb extends Entity

@onready var explosion: AnimatedSprite2D = $Explosion

signal _physics_process_signal


func _physics_process(_delta: float) -> void:
	_physics_process_signal.emit()


func explode(targets: Array[BombEffect.Target]) -> void:
	await _physics_process_signal
	await _physics_process_signal
	# It took me so long to debug wtf the solution ^^
	
	for entity: Area2D in get_overlapping_areas():
		for target: BombEffect.Target in targets:
			match target:
				BombEffect.Target.Cat:
					if entity is Cat:
						Game.witch.lose_life()
				BombEffect.Target.Witch:
					if entity is Witch:
						Game.witch.lose_life()

	explosion.play()
	await explosion.animation_finished
	queue_free()
