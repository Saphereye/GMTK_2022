extends Node2D

func _on_Area2D_area_entered(_area):
	$Sprite.material.set_shader_param("flashModifier", 1)
	$Timer.start()


func _on_Timer_timeout():
	$"Health Area/CollisionShape2D".disabled = true
	self.hide()
