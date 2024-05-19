extends HBoxContainer

@onready var rank_label = $Rank
@onready var user_label = $UserLabel
@onready var score_label = $ScoreLabel
@onready var water_consumed_label = $WaterConsumedLabel
@onready var water_wasted_label = $WaterWastedLabel

func setLabels(rank: int, user: String, score: int, waterConsumed: int, waterWasted: int):
	rank_label.text  = str(rank);
	user_label.text = user;
	score_label.text = str(score);
	water_consumed_label = str(waterConsumed);
	water_wasted_label = str(waterWasted);
