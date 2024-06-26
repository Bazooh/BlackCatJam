class_name Effect extends Node

@export var once : bool = true
var activated : bool

var item: Item
var cat: Cat
var witch: Witch


func activate():
	if once and activated:
		return
	
	activated = true
	_activate()


func _activate():
	pass
