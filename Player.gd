extends KinematicBody2D

export var MOVE_SPEED: float = 200.0

var velocity: Vector2 = Vector2.ZERO
var is_jumping: bool
var input_vector: Vector2

export var HEALTH: int = 6
export var JUMP_HEIGHT_INDICATOR: int  = 6
export var JUMP_TIME_TO_PEAK: float
export var JUMP_TIME_TO_DESCENT: float

var JUMP_HEIGHT: float = JUMP_HEIGHT_INDICATOR * (258/6)

onready var JUMP_VELOCITY: float = ((2.0 * JUMP_HEIGHT) / JUMP_TIME_TO_PEAK) * -1.0
onready var JUMP_GRAVITY: float = ((-2.0 * JUMP_HEIGHT) / (JUMP_TIME_TO_PEAK * JUMP_TIME_TO_PEAK)) * -1.0
onready var FALL_GRAVITY: float = ((-2.0 * JUMP_HEIGHT) / (JUMP_TIME_TO_DESCENT * JUMP_TIME_TO_DESCENT)) * -1.0

enum STATE {
	IDLE,
	RUN,
	JUMP,
	FALL,
	BEFORE_JUMP,
	ATTACK
}

var state_memory = []

var current_state

func _ready() -> void:
	current_state = STATE.IDLE

func _physics_process(delta):
	input_vector = get_input_vector()
	
	if input_vector.x > 0:
		$Sprite.flip_h = false
	elif input_vector.x < 0:
		$Sprite.flip_h = true
	
	apply_fall_gravity(delta)
	
	match current_state:
		STATE.IDLE:
			$AnimationPlayer.play("Idle")
			
			if abs(input_vector.x) > 0:
				current_state = STATE.RUN
				continue
			
			if velocity.y > 0  and !is_on_floor():
				$CoyoteTimer.start()
				state_memory.push_back(STATE.IDLE)
				current_state = STATE.FALL
				continue
			
			if Input.is_action_just_pressed("jump"):
				state_memory.push_back(STATE.IDLE)
				current_state = STATE.JUMP
		
		STATE.RUN:
			$AnimationPlayer.play("Run")
			
			move_player_in_x()
			
			if abs(input_vector.x) < 0.1:
				current_state = STATE.IDLE
				continue
			
			if velocity.y > 0 and !is_on_floor():
				$CoyoteTimer.start()
				state_memory.push_back(STATE.RUN)
				current_state = STATE.FALL
				continue
			
			if Input.is_action_just_pressed("jump"):
				state_memory.push_back(STATE.RUN)
				current_state = STATE.JUMP
		
		STATE.JUMP:
			if is_on_floor():
				velocity.y = JUMP_VELOCITY
			
			if Input.is_action_just_released("jump") and velocity.y < 0:
				velocity.y = 0
			
			move_player_in_x()
			
			$AnimationPlayer.play("Jump_Up")
			
			if velocity.y > 0:
				current_state = STATE.FALL
			
			# Transition from BEFORE_JUMP to JUMP handled in "_on_AnimatedSprite_animation_finished()" method
		
		STATE.FALL:
			$AnimationPlayer.play("Jump_Down")
			velocity.x = input_vector.x * MOVE_SPEED
			
			if Input.is_action_just_pressed("jump") and !$CoyoteTimer.is_stopped():
				$CoyoteTimer.stop()
				current_state = STATE.JUMP
				velocity.y = JUMP_VELOCITY
				continue
			
			if is_on_floor():
				current_state = state_memory.pop_back()
	
	velocity = move_and_slide(velocity, Vector2.UP)


func _process(_delta: float) -> void:
	if HEALTH > 0:
		$"../CanvasLayer/UI/Full Heart".show()
		$"../CanvasLayer/UI/Full Heart".rect_size.x = 16 * HEALTH
	else:
		$"../CanvasLayer/UI/Full Heart".hide()
		
	$"../CanvasLayer/UI/Jump Height/Jump Height Indicator".rect_size.x = (90/6) * (JUMP_HEIGHT/258) * JUMP_HEIGHT_INDICATOR

func jump():
	velocity.y = JUMP_VELOCITY

func get_gravity() -> float:
	return JUMP_GRAVITY if velocity.y < 0.0 else FALL_GRAVITY

func move_player_in_x() -> void:
	velocity.x = input_vector.x * MOVE_SPEED

func get_input_vector() -> Vector2:
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)

func apply_fall_gravity(delta: float) -> void:
	velocity.y += get_gravity() * delta

func _on_Flash_TImer_timeout():
	$Sprite.material.set_shader_param("flashModifier", 0)
	$"../CanvasLayer/UI/Full Heart".material.set_shader_param("flashModifier", 0)
