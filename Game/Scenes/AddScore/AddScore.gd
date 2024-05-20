extends Node2D

const leaderboardScene = preload("res://Scenes/Leaderboard/Leaderboard.tscn")

@onready var playerNameInput = $CanvasLayer/ScorePanel/PlayerNameInput;
@onready var httpRequest = $CanvasLayer/ScorePanel/PostEntryHttpRequest;

var isValid = false;

var score = 0;
var waterWasted = 0;
var waterConsumed = 0;

@onready var score_label = $CanvasLayer/ScorePanel/ScoreLabel
@onready var water_wasted_label = $CanvasLayer/ScorePanel/HBoxContainer/VBoxContainer/WaterWastedLabel
@onready var water_drank_label = $CanvasLayer/ScorePanel/HBoxContainer/VBoxContainer/WaterDrankLabel


func setScore(waterWasted: int, waterConsumed: int):
	self.score = max(waterConsumed - max((waterWasted / 10), 0), 0);
	self.waterWasted = waterWasted;
	self.waterConsumed = waterConsumed;
	score_label.text = str(self.score);
	water_wasted_label.text = str(self.waterWasted) + ' ml';
	water_drank_label.text = str(self.waterConsumed) + ' ml';

func _on_player_name_input_text_changed():
	isValid = (playerNameInput.text as String).length() > 1;
	$CanvasLayer/ScorePanel/BtnEnabledImg.visible = isValid;
	$CanvasLayer/ScorePanel/BtnDisabledImg.visible = !isValid;

func _on_add_to_leadearboard_btn_pressed():
	Global.playUISFX();
	if (!isValid):
		return;
		
	var payload = {
		'username': playerNameInput.text,
		'score': score,
		'waterWasted': waterWasted,
		'waterConsumed': waterConsumed
	}
	httpRequest.request(Global.API_URL, ['Content-Type: application/json'],
		HTTPClient.METHOD_POST, 
		JSON.stringify(payload)
	);

func _on_post_entry_http_request_request_completed(result, response_code, headers, body):
	var scene = leaderboardScene.instantiate();
	get_tree().root.add_child(scene);
	self.queue_free();

func _on_skip_btn_pressed():
	Global.playUISFX();
	var scene = leaderboardScene.instantiate();
	get_tree().root.add_child(scene);
	self.queue_free();
