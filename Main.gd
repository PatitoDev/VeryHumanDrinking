extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	face.setOpenMouth(false);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var waterCount = 0;

func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print(waterCount);
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
