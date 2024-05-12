extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var waterCount = 0;

func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print(waterCount);
	waterCount += 1;
