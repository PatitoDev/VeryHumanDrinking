extends Node2D

var addScoreScene = preload("res://Scenes/AddScore/AddScore.tscn");

@onready var face = $Face
@onready var faucet = $Faucet
@onready var score_ui = $ScoreUi

@onready var cup = $Cup;

var duration = 10;
var time = 0;
var waterConsumed = 0;
var waterWasted = 0;

var isTimed = false;
var hasEnded = false;

func _ready():
	score_ui.updateScore(waterConsumed)
	if !isTimed:
		score_ui.updateTime(0);
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	if (!isTimed || hasEnded):
		return;
	time += delta;
	score_ui.updateTime(floor(duration - time));
	if (duration - time) <= 0:
		hasEnded = true;
		end();

func end():
	var scene = addScoreScene.instantiate();
	get_tree().root.add_child(scene);
	scene.setScore(waterWasted, waterConsumed);
	queue_free();

func _physics_process(delta):
	face.pointEyesTowards(cup.global_position);
	if (cup.global_position.y > $WaterDespawnPoint.global_position.y):
		cup.global_position.y = 0;
	
	if (cup.global_position.x > $CupRespawnRight.global_position.x):
		cup.global_position.x = 20;
	
	if (cup.global_position.x < $CupRespawnLeft.global_position.x):
		cup.global_position.x = 1113;

func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if (body != null && body.is_in_group('NotWater')):
		return;
	waterConsumed += 1;
	score_ui.updateScore(waterConsumed)
	face.playGulp();

func _on_flow_control_panel_spawn_water():
	faucet.onSpawnWater();
