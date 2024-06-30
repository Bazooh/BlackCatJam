class_name Effect extends Node


enum Trigger { Cat, Witch, Ground, Start, None }


@export var once: bool = true
@export var trigger := Trigger.Cat
var activated: bool

@onready var entity: Entity = get_parent().get_parent()


func _ready() -> void:
	match trigger:
		Trigger.Cat:
			entity.touch_cat.connect(activate)
		Trigger.Witch:
			entity.touch_witch.connect(activate)
		Trigger.Ground:
			entity.touch_ground.connect(activate)
		Trigger.Start:
			activate()


func activate(triggerer = null):
	if once and activated:
		return
	
	activated = true
	_activate(triggerer)


func _activate(_triggerer):
	pass
