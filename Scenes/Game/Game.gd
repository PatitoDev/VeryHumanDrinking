extends Node2D

@onready var face = $Face
@onready var faucet = $Faucet
@onready var score_ui = $ScoreUi

@onready var cup = $Cup;

var duration = 30;
var time = 0;
var waterCount = 0;

func _ready():
	score_ui.updateScore(waterCount)
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	time += delta;
	score_ui.updateTime(floor(duration - time));

func _physics_process(delta):
	if (cup.global_position.y > $WaterDespawnPoint.global_position.y):
		cup.global_position.y = 0;
	
	if (cup.global_position.x > $CupRespawnRight.global_position.x):
		cup.global_position.x = 20;
	
	if (cup.global_position.x < $CupRespawnLeft.global_position.x):
		cup.global_position.x = 1113;
	

func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if (body != null && body.is_in_group('NotWater')):
		return;
	waterCount += 1;

func _on_flow_control_panel_spawn_water():
	faucet.onSpawnWater();
	score_ui.updateScore(waterCount)
