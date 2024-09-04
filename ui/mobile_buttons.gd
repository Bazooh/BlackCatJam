class_name MobileButtons extends Node2D


func _ready() -> void:
	visible = OS.has_feature("mobile")
