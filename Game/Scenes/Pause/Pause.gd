extends Node2D

@onready var canvas = $CanvasLayer
@onready var volume_slider = $"CanvasLayer/Control/VBoxContainer/Control/Volume Slider"
var masterIndex = AudioServer.get_bus_index("Master");

func _ready():
	volume_slider.value = AudioServer.get_bus_volume_db(masterIndex);
	canvas.visible = false;

func _physics_process(delta):
	if Input.is_action_just_pressed("pause"):
		canvas.visible = !canvas.visible;
		get_tree().paused = canvas.visible;

func _on_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(masterIndex, value);
	AudioServer.set_bus_mute(masterIndex, value <= -12);

func _on_continue_btn_pressed():
	canvas.visible = false;
	get_tree().paused = false;

func _on_main_menu_btn_pressed():
	canvas.visible = false;
	get_tree().paused = false;
	get_parent().queue_free();
