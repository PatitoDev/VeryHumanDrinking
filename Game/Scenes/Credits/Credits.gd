extends Node2D

var mainScene = preload("res://Scenes/MainMenu/MainMenu.tscn");

func _on_credits_btn_pressed():
	var scene = mainScene.instantiate();
	get_tree().root.add_child(scene);
	queue_free();
