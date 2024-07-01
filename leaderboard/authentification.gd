extends Node


const CREDENTIAL_FILE = "user://" + Credentials.COMPANY_NAME + ".data"
const IS_DEVELOPMENT_BUILD = true

var auth_http: HTTPRequest
var get_name_http: HTTPRequest
var set_name_http: HTTPRequest

signal auth_completed(value: Dictionary)
signal change_player_name_completed(value: Dictionary)
signal get_name_completed(value: Dictionary)


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	await _authentication_request()


func _authentication_request() -> Dictionary:
	var player_session_exists := false
	var player_identifier: String
	var file := FileAccess.open(CREDENTIAL_FILE, FileAccess.READ)
	if file != null:
		player_identifier = file.get_as_text()
		print("player ID = " + player_identifier)
		file.close()
 
	if player_identifier != null and player_identifier.length() > 1:
		print("player session exists, ID = " + player_identifier)
		player_session_exists = true

	var data := { "game_key": Credentials.API_KEY, "game_version": "0.0.0.1", "development_mode": IS_DEVELOPMENT_BUILD }
	if player_session_exists:
		data["player_identifier"] = player_identifier
	
	var headers = ["Content-Type: application/json"]
	
	auth_http = HTTPRequest.new()
	add_child(auth_http)
	
	auth_http.request_completed.connect(_on_authentication_request_completed)
	auth_http.request("https://api.lootlocker.io/game/v2/session/guest", headers, HTTPClient.METHOD_POST, JSON.stringify(data))
	
	print(data)
	return await auth_completed


func _on_authentication_request_completed(_result, _response_code, _headers, body) -> void:
	var json := JSON.new()
	json.parse(body.get_string_from_utf8())
	
	var file := FileAccess.open(CREDENTIAL_FILE, FileAccess.WRITE)
	file.store_string(json.get_data().player_identifier)
	file.close()
	
	Credentials.session_token = json.get_data().session_token
	
	print(json.get_data())
	
	auth_http.queue_free()
	auth_completed.emit(json.get_data())


func change_player_name(new_player_name: String) -> Dictionary:
	print("Changing player name")

	var data := { "name": new_player_name }
	var url := "https://api.lootlocker.io/game/player/name"
	var headers: Array[String] = ["Content-Type: application/json", "x-session-token:" + Credentials.session_token]
	
	set_name_http = HTTPRequest.new()
	add_child(set_name_http)
	set_name_http.request_completed.connect(_on_player_set_name_request_completed)
	
	set_name_http.request(url, headers, HTTPClient.METHOD_PATCH, JSON.stringify(data))

	return await change_player_name_completed


func _on_player_set_name_request_completed(_result, _response_code, _headers, body) -> void:
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	
	print(json.get_data())
	set_name_http.queue_free()

	change_player_name_completed.emit(json.get_data())


func get_player_name() -> Dictionary:
	print("Getting player name")
	var url := "https://api.lootlocker.io/game/player/name"
	var headers: PackedStringArray = ["Content-Type: application/json", "x-session-token:" + Credentials.session_token]
	
	get_name_http = HTTPRequest.new()
	add_child(get_name_http)
	get_name_http.request_completed.connect(_on_player_get_name_request_completed)
	
	get_name_http.request(url, headers, HTTPClient.METHOD_GET, "")

	return await get_name_completed


func _on_player_get_name_request_completed(_result, _response_code, _headers, body) -> void:
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	
	print(json.get_data())
	get_name_http.queue_free()

	get_name_completed.emit(json.get_data())
