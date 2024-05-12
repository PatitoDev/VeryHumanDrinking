extends Node2D

@onready var sprite = $Face
var waterCounter = 0;

func _on_water_counter_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	waterCounter += 1;
	$Label.text = 'Drink: ' + str(waterCounter);

func setOpenMouth(value: bool):
	if (value):
		sprite.frame = 1;
		return
	sprite.frame = 0;
