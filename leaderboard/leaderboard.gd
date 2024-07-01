class_name UILeaderboard extends Leaderboard


const score_line_scene: PackedScene = preload("res://leaderboard/score_line.tscn")
const leaderboard: PackedScene = preload("res://leaderboard/leaderboard.tscn")


static func show(scene_to_hide: Node):
	Game.back_scene = scene_to_hide
	scene_to_hide.visible = false
	var scene = leaderboard.instantiate()
	scene_to_hide.get_parent().add_child(scene)


func add_score_line(line):
	var score_line = score_line_scene.instantiate()
	score_line.setName(line.player.name)
	score_line.setScore(line.score)
	score_line.setRank(line.rank)
	%Container.add_child(score_line)


func _ready():
	var board = await _get_leaderboards()
	for item in board.items:
		add_score_line(item)


func _on_back_pressed():
	Game.back_scene.visible = true
	queue_free()
