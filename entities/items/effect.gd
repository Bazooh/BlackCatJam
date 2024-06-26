class_name Effect extends Node


enum Trigger { Cat, Witch, Ground }


@export var once: bool = true
@export var trigger := Trigger.Cat
var activated: bool

@onready var item: Item = get_parent().get_parent()


func _ready() -> void:
	match trigger:
		Trigger.Cat:
			item.touch_cat.connect(activate)
		Trigger.Witch:
			item.touch_witch.connect(activate)
		Trigger.Ground:
			item.touch_ground.connect(activate)


func activate(entity = null):
	if once and activated:
		return
	
	activated = true
	_activate(entity)


func _activate(_entity):
	pass
