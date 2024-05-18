extends Node2D

#5
@onready var number_strip = $FirstDigit/ColorRect/NumberStripContainer/NumberStrip
@onready var number_strip_2 = $FirstDigit/ColorRect/NumberStripContainer/NumberStrip2

var value = 00000;
var imgHeight = 7 * 4;

func _ready():
	setNumber(0);

func setNumber(value: int):
	var positionY = -(value * imgHeight);
	create_tween().tween_property(number_strip, 'position', Vector2(0, -positionY), 1);
