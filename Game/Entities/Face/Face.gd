extends Node2D
@onready var animationPlayer = $AnimationPlayer
@onready var gulp_animation_player = $GulpAnimationPlayer
@onready var eyes = $Eyes

func pointEyesTowards(target: Vector2):
	var angle = rad_to_deg(target.angle_to_point(eyes.global_position));
	if (angle < 0):
		angle = 360 - abs(angle);
	# 6 sides 
	var frame = ceil(angle / 60)
	eyes.frame = frame - 1;

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

func playGulp():
	if (!gulp_animation_player.is_playing()):
		gulp_animation_player.play('gulp');
