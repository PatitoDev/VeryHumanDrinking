extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	face.setOpenMouth(false);
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var waterCount = 0;

func _physics_process(delta):
	if ($Cup.global_position.y > $WaterDespawnPoint.global_position.y):
		$Cup.global_position.y = 0;

func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	waterCount += 1;

@onready var face = $Face

func _on_open_mouth_trigger_body_entered(body):
	if (!body.is_in_group('cup')):
		return;
	face.setOpenMouth(true);

func _on_open_mouth_trigger_body_exited(body):
	if (!body.is_in_group('cup')):
		return;
	face.setOpenMouth(false);

@onready var faucet = $Faucet

func _on_flow_control_panel_spawn_water():
	faucet.onSpawnWater();
