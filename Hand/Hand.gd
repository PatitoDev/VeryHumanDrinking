extends CharacterBody2D

@onready var armPivot = $ArmPivot
@onready var animationPlayer = $AnimationPlayer
@onready var handCenter = $ArmPivot/HandCenter
@onready var grabArea = $ArmPivot/HandCenter/GrabArea
var holdedElement = null;
var grabbedCup = null;
var rotationStrength = 5;

var rotationStep = 2;
var maxRotationSteps = 4;

func _ready():
	updateRotationStep(2);

func _physics_process(delta):
	if (holdedElement == null):
		global_position = get_global_mouse_position();
	
	if (Input.is_action_pressed('rotateRight') && holdedElement == null):
		#rotation_degrees += rotationStrength;
		updateRotationStep(rotationStep + 1)
		
	if (Input.is_action_pressed('rotateLeft') && holdedElement == null):
		#rotation_degrees -= rotationStrength;
		updateRotationStep(rotationStep - 1)
	
	if (Input.is_action_just_pressed("grab")):
		if (grabbedCup != null || holdedElement != null):
			return;
		var areas = grabArea.get_overlapping_areas();
		for area in areas:
			if ((area as Node2D).is_in_group('grabbable')):
				grabbedCup = area.get_parent();
				grabbedCup.setTarget(handCenter);
				
			if ((area as Node2D).is_in_group('hooldable')):
				rotationStep = 2;
				animationPlayer.play("Hold")
				holdedElement = area.get_parent();
				holdedElement.get_parent().setIsGrabbed(true);

	if (Input.is_action_just_released("grab")):
		if holdedElement != null:
			holdedElement.get_parent().setIsGrabbed(false);
			holdedElement = null;
			armPivot.rotation_degrees = 0;
			updateRotationStep(2);
			animationPlayer.play("T")

		if grabbedCup != null:
			grabbedCup.setTarget(null);
			grabbedCup = null;
	
	if (holdedElement != null):
		armPivot.rotation_degrees = holdedElement.rotation_degrees;
		global_position = holdedElement.get_node('HandleMarker').global_position;

func updateRotationStep(value: int):
	if (animationPlayer.is_playing()):
		return;

	var newValue = clamp(value, 0, maxRotationSteps)
	if newValue != value:
		return;

	rotationStep = newValue;
	match rotationStep:
		0:
			animationPlayer.play('L');
		1:
			animationPlayer.play('LT');
		2:
			animationPlayer.play('T');
		3:
			animationPlayer.play('RT');
		4:
			animationPlayer.play('R');
