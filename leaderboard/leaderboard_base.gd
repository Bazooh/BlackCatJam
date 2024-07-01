class_name Leaderboard extends Node

var leaderboard_http: HTTPRequest
var submit_score_http: HTTPRequest

var score: int

signal upload_score_completed(value: Dictionary)
signal get_leadboard_completed(value: Dictionary)


func _get_leaderboards(n_first: int = 10) -> Dictionary:
	print("Getting leaderboards")
	var url = "https://api.lootlocker.io/game/leaderboards/" + Credentials.LEADERBOARD_KEY + "/list?count=" + str(n_first)
	var headers = ["Content-Type: application/json", "x-session-token:" + Credentials.session_token]
	
	leaderboard_http = HTTPRequest.new()
	add_child(leaderboard_http)
	leaderboard_http.request_completed.connect(_on_leaderboard_request_completed)
	
	leaderboard_http.request(url, headers, HTTPClient.METHOD_GET, "")

	return await get_leadboard_completed


func _on_leaderboard_request_completed(_result, _response_code, _headers, body) -> void:
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	
	print(json.get_data())

	get_leadboard_completed.emit(json.get_data())


func _upload_score(new_score: int) -> Dictionary:
	var data = { "score": str(new_score) }
	var headers = ["Content-Type: application/json", "x-session-token:" + Credentials.session_token]
	submit_score_http = HTTPRequest.new()
	add_child(submit_score_http)
	submit_score_http.request_completed.connect(_on_upload_score_request_completed)

	submit_score_http.request("https://api.lootlocker.io/game/leaderboards/" + Credentials.LEADERBOARD_KEY + "/submit", headers, HTTPClient.METHOD_POST, JSON.stringify(data))

	print(data)

	return await upload_score_completed


func _on_upload_score_request_completed(_result, _response_code, _headers, body) -> void:
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	
	print(json.get_data())
	
	submit_score_http.queue_free()

	upload_score_completed.emit(json.get_data())
