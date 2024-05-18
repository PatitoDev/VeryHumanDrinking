extends Node2D

@onready var scoreDigit2 = $Digit2
@onready var scoreDigit1 = $Digit1

func updateTime(value: int):
	var digits = str(value).lpad(2, '0').split();
	scoreDigit1.setNumber(int(digits[1]));
	scoreDigit2.setNumber(int(digits[0]));

func updateScore(value: int):
	print(value)
	var digits = str(value).lpad(6, 'X');
	print(digits)
	var digitLabels = [
		$Digits/DigitalDigits, $Digits/DigitalDigits2, $Digits/DigitalDigits3, 
		$Digits/DigitalDigits4, $Digits/DigitalDigits5, $Digits/DigitalDigits6
	];
	
	var i = 0;
	for digit in digits:
		if (digit == 'X'):
			digitLabels[i].frame = 10;
		else:
			digitLabels[i].frame = int(digit);
		i += 1;
