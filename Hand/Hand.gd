extends CharacterBody2D

@onready var grabArea = $GrabArea
var grabbedCup = null;
var rotationStrength = 5;

func _physics_process(delta):	
	global_position = get_global_mouse_position();
	
	if (Input.is_action_pressed('rotateRight')):
		rotation_degrees += rotationStrength;
		
	if (Input.is_action_pressed('rotateLeft')):
		rotation_degrees -= rotationStrength;
	
	if (Input.is_action_just_pressed("grab")):
		var areas = grabArea.get_overlapping_areas();
		for area in areas:
			if ((area as Node2D).is_in_group('grabbable')):
				grabbedCup = area.get_parent();
				grabbedCup.setTarget(self);

	if (Input.is_action_just_released("grab") and grabbedCup != null):
		grabbedCup.setTarget(null);
		grabbedCup = null;
