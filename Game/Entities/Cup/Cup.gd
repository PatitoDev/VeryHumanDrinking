extends RigidBody2D
@onready var audioStreamPlayer2 = $AudioStreamPlayer2
@onready var audioStreamPlayer = $AudioStreamPlayer
var _target: Node2D = null;

const glassSFXs = [ 
	preload("res://Audio/Cup/sfx_glass_00.wav"),
	preload("res://Audio/Cup/sfx_glass_01.wav"),
	preload("res://Audio/Cup/sfx_glass_02.wav"),
	preload("res://Audio/Cup/sfx_glass_03.wav")
]

const faucetSFXs = [
	preload("res://Audio/Cup/sfx_glass_faucet_clash_00.wav"),
	preload("res://Audio/Cup/sfx_glass_faucet_clash_01.wav"),
	preload("res://Audio/Cup/sfx_glass_faucet_clash_02.wav"),
	preload("res://Audio/Cup/sfx_glass_faucet_clash_03.wav")
]

func _ready() -> void:
	lock_rotation = false;

func setTarget(target: Node2D):
	lock_rotation = target != null;
	_target = target;

func _physics_process(delta):
	if _target:
		var I = 5000*mass / 7#infuence
		var S = 20#stiffness 
		var P = _target.global_position - global_transform.origin
		var M = mass
		var V = linear_velocity
		var impulse = (I*P) - (S*M*V)
		apply_central_impulse(impulse * delta)
		rotation_degrees = _target.rotation_degrees;

func _on_area_sf_xs_body_entered(body):
	audioStreamPlayer.stream = glassSFXs.pick_random();
	audioStreamPlayer.play();
	audioStreamPlayer2.stream = faucetSFXs.pick_random();
	audioStreamPlayer2.play();

@onready var water_filling_player = $WaterFillingPlayer
@onready var waterFillingSFXs = [
	preload("res://Audio/Water/sfx_glass_filling_00.wav"),
	preload("res://Audio/Water/sfx_glass_filling_01.wav")
]

var filledAmount = 0;
var timer = null;

func _on_water_filling_collider_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if (water_filling_player.playing || body != null):
		return;
	filledAmount += 1;
	checkIfWaterFillingSFXShouldPlay();

func _on_water_filling_collider_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	filledAmount -= 1;

func checkIfWaterFillingSFXShouldPlay():
	return;
	if (filledAmount >= 3):
		return;
	
	if (timer == null || timer.time_left == 0):
		timer = get_tree().create_timer(1);
		return;

	if (water_filling_player.playing):
		return;
	
	water_filling_player.stream = waterFillingSFXs.pick_random();
	water_filling_player.play();
