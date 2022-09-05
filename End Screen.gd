extends Node2D

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		_on_Button_button_down()

func _on_Button_button_down():
	get_tree().change_scene("res://Level 0.tscn")
