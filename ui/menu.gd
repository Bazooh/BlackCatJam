extends Control

const LEVEL = preload("res://level/level.tscn")

@export var wait_time := 1.0
@export var wait_before_fade_time := 0.75
@export var transition_time := 1.25

@onready var menu_cat: MenuCat = $MenuCat
@onready var menu_witch: MenuWitch = $MenuWitch
@onready var menu_camera: MenuCamera = $MenuCamera

@onready var music: AudioStreamPlayer = $Music
@onready var meow: RandomSound = $Meow

@onready var ui: TextureRect = $UI

@onready var pseudo: LineEdit = %Pseudo


func get_player_name() -> String:
	return (await Authentification.get_player_name()).name


func _ready():
	get_tree().paused = false
	# pseudo.text = await get_player_name()


func start():
	# if await get_player_name() == "":
	# 	return
	
	# Authentification.change_player_name(pseudo.text)

	menu_cat.start()
	menu_witch.start()
	ui.hide()
	music.stop()
	meow.play_random_sound()
	
	await get_tree().create_timer(wait_time, true).timeout
	
	menu_camera.transition()
	menu_cat.run()
	
	await get_tree().create_timer(wait_before_fade_time, true).timeout
	
	Fade.fade_out()
	await get_tree().create_timer(transition_time, true).timeout
	
	load_scene()
	

func load_scene():
	get_tree().change_scene_to_packed(LEVEL)

func _on_button_pressed() -> void:
	ButtonSound.play_sound()
	start()
