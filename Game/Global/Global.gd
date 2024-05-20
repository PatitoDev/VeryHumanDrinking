extends Node2D

func playUISFX():
	$UISfx.play();

func playEndSFX():
	$EndGameSFX.play();

var API_URL = 'https://api.elpato.dev/VeryHumanClimbing/entry';
