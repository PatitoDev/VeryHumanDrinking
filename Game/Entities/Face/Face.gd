extends Node2D
@onready var animationPlayer = $AnimationPlayer

func setOpenMouth(value: bool):
	if (value):
		animationPlayer.play("Open");
		return
	animationPlayer.play("Close");

func _on_open_mouth_trigger_body_entered(body):
	if (!body.is_in_group('cup')):
		return;
	setOpenMouth(true);

func _on_open_mouth_trigger_body_exited(body):
	if (!body.is_in_group('cup')):
		return;
	setOpenMouth(false);
