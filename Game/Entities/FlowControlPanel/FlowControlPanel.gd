extends Node2D
var objects: Array[Array] = []

signal SpawnWater;

@onready var openSFXs = [
	preload("res://Audio/Faucet/sfx_faucet_open_00.wav"),
	preload("res://Audio/Faucet/sfx_faucet_open_01.wav")
]

@onready var closeSFXs = [
	preload("res://Audio/Faucet/sfx_faucet_close_00.wav"),
	preload("res://Audio/Faucet/sfx_faucet_close_01.wav")
]

@onready var audioSfxWaterFlowing = $AudioSfxWaterFlowing
@onready var audioSFXPlayer = $AudioSfx

@onready var handleMarker = $HandleOrigin/HandleMarker
@onready var grabHandleArea = $HandleOrigin/GrabHandleArea
@onready var waterFlowTimer = $WaterFlowTimer
@onready var handleOrigin = $HandleOrigin

@onready var pointer = $Pointer
@onready var pointer_2 = $Pointer2
@onready var pointer_3 = $Pointer3

var rotationIgnoreThreshold = 180;
var waterFlow = 0;
var maxWaterFlow = 270;

var initialPositionDifference = null;
var isGrabbed = false;

var waterCreated = 0;
var isOpen = false;

func _ready() -> void:
	setWaterFlow(0)

func setWaterFlow(value: int):
	var newValue = clamp(value, 0, maxWaterFlow);
	if (abs(newValue - waterFlow) > rotationIgnoreThreshold):
		if (waterFlow > 180):
			newValue = maxWaterFlow;
		else:
			newValue = 0;
	waterFlow = newValue;
	handleOrigin.rotation_degrees = waterFlow;

	var time = maxWaterFlow - waterFlow;
	var emitTime = pow(time / 500.0, 2);
	waterFlowTimer.wait_time = max(emitTime, 0.0001);
	
	audioSfxWaterFlowing.volume_db = pow((waterFlow / 10), 2) / 50;
	
	if waterFlow > 10:
		if waterFlowTimer.is_stopped():
			waterFlowTimer.start();
			setIsOpen(true);
	else:
		if !waterFlowTimer.is_stopped():
			waterFlowTimer.stop();
			setIsOpen(false);

func setIsOpen(value: bool):
	if (isOpen == value):
		return;
	isOpen = value;
	if (value):
		audioSFXPlayer.stream = openSFXs.pick_random();
		audioSfxWaterFlowing.play();
	else:
		audioSFXPlayer.stream = closeSFXs.pick_random();
		audioSfxWaterFlowing.stop();
	audioSFXPlayer.play();

func setIsGrabbed(value: bool):
	isGrabbed = value;
	var handledDiff = handleOrigin.global_position - handleMarker.global_position;
	initialPositionDifference = get_global_mouse_position() + handledDiff;

func _physics_process(delta):
	if (isGrabbed):
		var mousePos = get_global_mouse_position();
		var angle = rad_to_deg(mousePos.angle_to_point(initialPositionDifference)) + 180;
		setWaterFlow(angle);

@onready var first_digit = $Counter/FirstDigit
@onready var second_digit = $Counter/SecondDigit
@onready var third_digit = $Counter/ThirdDigit
@onready var fourth_digit = $Counter/FourthDigit
@onready var fifth_digit = $Counter/FifthDigit

func _on_timer_timeout():
	SpawnWater.emit();
	waterCreated += 1;

	var totalAsString:String = str(waterCreated).lpad(5, "0");
	totalAsString.split();
	first_digit.setNumber(int(totalAsString[4]));
	second_digit.setNumber(int(totalAsString[3]));
	third_digit.setNumber(int(totalAsString[2]));
	fourth_digit.setNumber(int(totalAsString[1]));
	fifth_digit.setNumber(int(totalAsString[0]));

func _on_pointer_timer_timeout():
	pointer.rotation_degrees += 90;

func _on_pointer_timer_2_timeout():
	pointer_2.rotation_degrees += 90;

func _on_pointer_timer_3_timeout():
	pointer_3.rotation_degrees += 90;
