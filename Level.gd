extends Node2D

var collider_1_disabled = false

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready():
	$Dice_Coliiders/Dice.hide()


func _on_Collider_1_area_entered(_area):
	if !collider_1_disabled:
		print_debug("Collide for dice")
		rng.randomize()
		var rand_num = randi() % 6
		$Dice_Coliiders/Dice/Sprite.frame = rand_num
		$Player.HEALTH = rand_num + 1
		$Dice_Coliiders/Dice.show()
		collider_1_disabled = true


func _on_Spike_Area_area_entered(_area):
	print_debug("Collided with spikes")
	$Player.HEALTH = int(clamp($Player.HEALTH - 1, 0, 6))
	$Player/Sprite.material.set_shader_param("flashModifier", 1)
	$"CanvasLayer/UI/Full Heart".material.set_shader_param("flashModifier", 1)
	$"Player/Flash TImer".start()
	$Player.position = Vector2(128,296)


func _on_Health_Area_area_entered(_area):
	print_debug("Collecte Orb")
	$Player.HEALTH = int(clamp($Player.HEALTH + 1, 0, 6))


func _on_InstaKill_area_entered(area):
	$Player.HEALTH = 0


func _on_Enemy_Area_area_entered(area):
	print_debug("Collided with enemy")
	$Player.HEALTH = int(clamp($Player.HEALTH - 1, 0, 6))
	$Player/Sprite.material.set_shader_param("flashModifier", 1)
	$"CanvasLayer/UI/Full Heart".material.set_shader_param("flashModifier", 1)
	$"Player/Flash TImer".start()
	$Player.position = Vector2(128,296)
