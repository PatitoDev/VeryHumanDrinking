extends Node2D

var apiUrl = 'http://localhost:8989';

@onready var playerNameInput = $CanvasLayer/ScorePanel/PlayerNameInput;
@onready var httpRequest = $CanvasLayer/ScorePanel/PostEntryHttpRequest;

var isValid = false;

var score = 0;
var waterWasted = 0;
var waterConsumed = 0;

func setScore(waterWated: int, waterConsumed: int):
	self.score = waterConsumed - max((waterWasted / 100), 0);
	self.waterWasted = waterWasted;
	self.waterConsumed = waterConsumed;

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
	httpRequest.request(apiUrl + '/entry', ['Content-Type: application/json'],
		HTTPClient.METHOD_POST, 
		JSON.stringify(payload)
	);

func _on_post_entry_http_request_request_completed(result, response_code, headers, body):
	pass;
