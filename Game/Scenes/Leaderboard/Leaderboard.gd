extends Node2D

var apiUrl = 'http://localhost:8989';

const entryScene = preload("res://UI/LeaderboardEntry/LeaderboardEntry.tscn");
@onready var leaderboardEntriesContainer = $CanvasLayer/LeaderboardPanel/ScrollContainer/VBoxContainer;
@onready var getLeaderboardHttpRequest = $CanvasLayer/LeaderboardPanel/GetLeaderboardHttpRequest;

func _on_back_btn_pressed():
	Global.playUISFX();
	get_parent().get_node('MainMenu').playMusic();
	self.queue_free();

func _ready():
	getLeaderboardHttpRequest.request(apiUrl + '/entry', [], HTTPClient.METHOD_GET);

func _on_get_leaderboard_http_request_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	
	var counter = 1;
	for entryData in json:
		var entry = entryScene.instantiate();
		leaderboardEntriesContainer.add_child(entry);
		entry.setLabels(counter, entryData['username'], entryData['score'], entryData['waterConsumed'], entryData['waterWasted']);
		counter += 1;
