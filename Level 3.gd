extends Node2D

var collider_1_disabled = false
var collider_2_disabled = false
var transition_time: float = 1.0
var level_completed: bool = false

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready():
	$Player.position = $"Respawn Point".position
	
	$"Dice Tree/Dice/Sprite".hide()
	$"Dice Tree/Dice2/Sprite".hide()
	rng.randomize()

func _physics_process(delta):
	if $Player.HEALTH <= 0:
		get_tree().change_scene("res://End Screen.tscn")
	
	if $"Transition Timer".get_time_left() != 0:
		$"Screen Transition/ColorRect".color = Color(
			0.0,
			0.0,
			0.0,
			1 - $"Transition Timer".get_time_left()/transition_time
		)

func _on_Spike_Area_area_entered(_area):
	print_debug("Collided with spikes")
	$Player.HEALTH = int(clamp($Player.HEALTH - 1, 0, 6))
	$Player/Sprite.material.set_shader_param("flashModifier", 1)
	$"CanvasLayer/UI/Full Heart".material.set_shader_param("flashModifier", 1)
	$"Player/Flash TImer".start()
	$Player.position = $"Respawn Point".position


func _on_Health_Area_area_entered(_area):
	print_debug("Collected Orb")
	$Player.HEALTH = int(clamp($Player.HEALTH + 1, 0, 6))


func _on_InstaKill_area_entered(area):
	$Player.HEALTH = 0


func _on_Collider_1_area_entered(area):
	if !collider_1_disabled:
		print_debug("Collide for dice")
		var rand_num = rng.randi() % 6
		$"Dice Tree/Dice/Sprite".frame = rand_num
		$Player.HEALTH = rand_num + 1
		$"Dice Tree/Dice/Sprite".show()
		collider_1_disabled = true


func _on_Level_Completed_Area_area_entered(area):
	if !level_completed:
		$"Transition Timer".start(transition_time)
		level_completed = true


func _on_Transition_Timer_timeout():
	get_tree().change_scene("res://End Screen.tscn")


func _on_Enemy_Area_area_entered(area):
	print_debug("Collided with enemy")
	$Player.HEALTH = int(clamp($Player.HEALTH - 1, 0, 6))
	$Player/Sprite.material.set_shader_param("flashModifier", 1)
	$"CanvasLayer/UI/Full Heart".material.set_shader_param("flashModifier", 1)
	$"Player/Flash TImer".start()
	$Player.position = $"Respawn Point".position


func _on_Collider_2_area_entered(area):
	if !collider_2_disabled:
		print_debug("Collide for dice")
		var rand_num = rng.randi() % 6
		$"Dice Tree/Dice2/Sprite".frame = rand_num
		$Player.HEALTH = rand_num + 1
		$"Dice Tree/Dice2/Sprite".show()
		collider_2_disabled = true
