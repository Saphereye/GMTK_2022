extends Node2D

var bg_music = load("res://Andreas Theme.mp3")

func _ready():
	pass # Replace with function body.

func play_music():
	$AudioStreamPlayer.stream = bg_music
	$AudioStreamPlayer.play()
