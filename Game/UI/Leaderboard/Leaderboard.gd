extends Node2D

var apiUrl = 'http://localhost:8989';

const entryScene = preload("res://UI/LeaderboardEntry/LeaderboardEntry.tscn");
@onready var playerNameInput = $CanvasLayer/ScorePanel/PlayerNameInput;
@onready var postEntryHttpRequest = $CanvasLayer/ScorePanel/PostEntryHttpRequest;
@onready var leaderboardEntriesContainer = $CanvasLayer/LeaderboardPanel/ScrollContainer/VBoxContainer;
@onready var getLeaderboardHttpRequest = $CanvasLayer/LeaderboardPanel/GetLeaderboardHttpRequest;

var isValid = false;

var score = 50000000;
var waterWasted = 123124;
var waterConsumed = 123123;

func _on_player_name_input_text_changed():
	isValid = (playerNameInput.text as String).length() > 1;
	$CanvasLayer/ScorePanel/BtnEnabledImg.visible = isValid;
	$CanvasLayer/ScorePanel/BtnDisabledImg.visible = !isValid;

func _on_add_to_leadearboard_btn_pressed():
	if (!isValid):
		return;
		
	var payload = {
		'username': playerNameInput.text,
		'score': score,
		'waterWasted': waterWasted,
		'waterConsumed': waterConsumed
	}
	postEntryHttpRequest.request(apiUrl + '/entry', ['Content-Type: application/json'],
		HTTPClient.METHOD_POST, 
		JSON.stringify(payload)
	);

func _on_post_entry_http_request_request_completed(result, response_code, headers, body):
	getLeaderboardHttpRequest.request(apiUrl + '/entry', [], HTTPClient.METHOD_GET);
	$CanvasLayer/ScorePanel.visible = false;
	$CanvasLayer/LeaderboardPanel.visible = true;

func _on_get_leaderboard_http_request_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	
	var counter = 1;
	for entryData in json:
		var entry = entryScene.instantiate();
		leaderboardEntriesContainer.add_child(entry);
		entry.setLabels(counter, entryData['username'], entryData['score'], entryData['waterConsumed'], entryData['waterWasted']);
		counter += 1;
