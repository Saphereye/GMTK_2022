extends Node2D

var transition_time: float = 1.0
var level_completed: bool = false

func _ready():
	$Player.position = $"Respawn Point".position
	$Player.HEALTH = 6


func _process(_delta):
	if $Player.HEALTH <= 0:
		get_tree().change_scene("res://End Screen.tscn")
	
	if $"Transition Timer".get_time_left() != 0:
		$"Screen Transition/ColorRect".color = Color(
			0.0,
			0.0,
			0.0,
			1 - $"Transition Timer".get_time_left()/transition_time
		)


func _on_Level_Completed_Area_area_entered(_area):
	if !level_completed:
		$"Transition Timer".start(transition_time)
		level_completed = true


func _on_Transition_Timer_timeout():
	get_tree().change_scene("res://Level 1.tscn")
