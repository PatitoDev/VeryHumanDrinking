
extends Node2D

#5
@onready var number_strip = $ColorRect/NumberStripContainer/NumberStrip1
@onready var number_strip_2 = $ColorRect/NumberStripContainer/NumberStrip2
@onready var number_strip_3 = $ColorRect/NumberStripContainer/NumberStrip3
@onready var number_strip_container = $ColorRect/NumberStripContainer

var previousValue = 0;
var digitHeight = 7 * 4;
var imgHeight = digitHeight * 10

func _ready():
	setNumber(0);

func setNumber(value: int):
	var positionY1 = -(value * digitHeight);
	var positionY2 = positionY1 - 280;
	create_tween().tween_property(number_strip, 'position', Vector2(0, positionY1), 0.1).set_trans(Tween.TRANS_SPRING);
	create_tween().tween_property(number_strip_2, 'position', Vector2(0, positionY2), 0.1).set_trans(Tween.TRANS_SPRING);
	previousValue = value;
