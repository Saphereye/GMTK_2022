extends KinematicBody2D

export var MOVE_SPEED: float = 200.0

var fraction: float = 0.01
var returning: bool = false
onready var initial_pos: Vector2 = self.position

func _physics_process(delta):
	#print_debug(fraction)
	self.position.x  = move_toward(
		$"Point 1".position.x + initial_pos.x, 
		$"Point 2".position.x + initial_pos.x, 
		fraction * MOVE_SPEED
	)
	
	if returning:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false
	
	if fraction >= 1:
		returning = true
		fraction = 1
	elif fraction <= 0 :
		fraction = 0
		returning = false
	
	if !returning:
		fraction += delta
	else:
		fraction -= delta
