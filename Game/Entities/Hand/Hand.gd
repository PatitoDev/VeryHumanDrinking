extends CharacterBody2D

@onready var animationTree = $AnimationTree
@onready var armPivot = $ArmPivot
@onready var animationPlayer = $AnimationPlayer
@onready var handCenter = $ArmPivot/HandCenter
@onready var grabArea = $ArmPivot/HandCenter/GrabArea
var holdedElement = null;
var grabbedCup = null;
var rotationStrength = 5;

var rotationStep = 2;
var maxRotationSteps = 4;

@onready var stateMachine: AnimationNodeStateMachinePlayback = animationTree['parameters/playback'];

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
				return;

		for area in areas:
			if ((area as Node2D).is_in_group('hooldable')):
				grabHandle(area);
				return;

	if (Input.is_action_just_released("grab")):
		if holdedElement != null:
			if grabAnimationTween != null:
				grabAnimationTween.stop();
				grabAnimationTween = null;
			
			holdedElement.get_parent().setIsGrabbed(false);
			holdedElement = null;
			armPivot.rotation_degrees = 0;
			rotationStep = 2;
			stateMachine.travel('2');

		if grabbedCup != null:
			grabbedCup.setTarget(null);
			grabbedCup = null;
	
	if (holdedElement != null && !isOnGrabbingAnimation):
		armPivot.rotation_degrees = holdedElement.rotation_degrees;
		global_position = holdedElement.get_node('HandleMarker').global_position;

var isOnGrabbingAnimation = false;
var grabAnimationTween = null;

func grabHandle(area: Node2D):
	rotationStep = 2;
	stateMachine.travel('2')
	isOnGrabbingAnimation = true;
	
	holdedElement = area.get_parent();
	grabAnimationTween = get_tree().create_tween()
	
	#var targetRotation = armPivot.rotation + armPivot.get_angle_to(holdedElement);
	
	var targetAngle = holdedElement.rotation_degrees;
	if (targetAngle > 180):
		targetAngle =  targetAngle - 360;
	
	grabAnimationTween.tween_property(armPivot, "rotation_degrees", targetAngle, 0.2)
	grabAnimationTween.tween_property(self, "global_position", holdedElement.get_node('HandleMarker').global_position, 0.2)
	
	grabAnimationTween.connect('finished', onGrabHandleAnimationFinished);
	# after animation has finished

func onGrabHandleAnimationFinished():
	stateMachine.travel('Hold')
	if (holdedElement != null):
		holdedElement.get_parent().setIsGrabbed(true);
		isOnGrabbingAnimation = false;

var isAnimating = false;

func updateRotationStep(value: int):
	if (isAnimating):
		return;
	
	var newValue = clamp(value, 0, maxRotationSteps)
	if newValue != value:
		return;
	
	isAnimating = true;
	
	rotationStep = newValue;
	match rotationStep:
		0:
			stateMachine.travel('0');
		1:
			stateMachine.travel('1');
		2:
			stateMachine.travel('2');
		3:
			stateMachine.travel('3');
		4:
			stateMachine.travel('4');

func _on_animation_tree_animation_finished(anim_name):
	isAnimating = anim_name != '0' && anim_name != '1' && anim_name != '2' && anim_name != '3' && anim_name != '4';
