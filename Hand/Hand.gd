extends CharacterBody2D

@onready var grabArea = $GrabArea
var grabbedCup = null;

func _physics_process(delta):
	return;
	global_position = get_global_mouse_position();
	if (Input.is_action_just_pressed("grab")):
		var bodies = grabArea.get_overlapping_bodies();
		for body in bodies:
			if ((body as Node2D).is_in_group('grabbable')):
				grabbedCup = body;

	if (Input.is_action_just_released("grab")):
		grabbedCup = null;

	if (grabbedCup):
		grabbedCup.global_position = global_position;
