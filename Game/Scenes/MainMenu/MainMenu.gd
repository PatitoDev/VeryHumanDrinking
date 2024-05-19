extends Node2D

var gameScene = preload("res://Scenes/Game/Game.tscn");
const leaderboardScene = preload("res://Scenes/Leaderboard/Leaderboard.tscn")
var creditscene = preload("res://Scenes/Credits/Credits.tscn");

func _ready():
	pass;

func _on_button_pressed():
	print('hello world')
	var game = gameScene.instantiate();
	game.isTimed = true;
	get_tree().root.add_child(game);
	queue_free();

func _on_endless_mode_pressed():
	var game = gameScene.instantiate();
	game.isTimed = false;
	get_tree().root.add_child(game);
	queue_free();

func _on_leaderboard_btn_pressed():
	var scene = leaderboardScene.instantiate();
	get_tree().root.add_child(scene);
	queue_free();

func _on_credits_btn_pressed():
	var scene = creditscene.instantiate();
	get_tree().root.add_child(scene);
	queue_free();
