extends Node2D

@onready var music = $Music
var gameScene = preload("res://Scenes/Game/Game.tscn");
const leaderboardScene = preload("res://Scenes/Leaderboard/Leaderboard.tscn")
var creditscene = preload("res://Scenes/Credits/Credits.tscn");

func _on_button_pressed():
	var game = gameScene.instantiate();
	game.isTimed = true;
	get_tree().root.add_child(game);
	music.stop();

func _on_endless_mode_pressed():
	var game = gameScene.instantiate();
	game.isTimed = false;
	get_tree().root.add_child(game);
	music.stop();

func _on_leaderboard_btn_pressed():
	var scene = leaderboardScene.instantiate();
	get_tree().root.add_child(scene);

func _on_credits_btn_pressed():
	var scene = creditscene.instantiate();
	get_tree().root.add_child(scene);

func playMusic():
	if music.playing:
		return;
	music.play();
