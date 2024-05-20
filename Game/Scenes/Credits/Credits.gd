extends Node2D

func _on_credits_btn_pressed():
	Global.playUISFX();
	get_parent().get_node('MainMenu').playMusic();
	queue_free();
