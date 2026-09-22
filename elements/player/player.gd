class_name Player
extends CharacterBody2D

@export_category("L/R Movement")
@export var max_speed: float = 300.0
@export var time_to_reach_zero_speed: float = 0.05
@export var time_to_reach_max_speed: float = 0.1

@export_category("Jumping")
@export var jump_height: float = 200.0
@export var jump_time_to_peak: float = 1.0
@export var jump_time_to_descend: float = 0.7
@export var max_air_jumps: int = 2

@export_category("Wall Jumping")
@export var wall_jump_force: float = 100
@export var horizontal_lock_time: float = 0.05
@export var wall_jump_coyote_time: float = 0.2

@export_category("Other")
@export_range(0.0, 1.0) var sliding_factor: float = 0.75
@export var max_gravity: float = 800.0
@export var max_float_gravity: float = 600.0
@export var jump_pad_velocity: float = 900.0
@export var squish_and_stretch_speed: float = 3.0
@export var squish_factor: float = 3.0
@export var stretch_factor: float = 1.5

@onready var jump_velocity: float = (2.0 * jump_height) / (jump_time_to_peak) * -1.0
@onready var jump_gravity: float = (-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak) * -1.0
@onready var fall_gravity: float = (-2.0 * jump_height) / (jump_time_to_descend * jump_time_to_descend) * -1.0

@onready var cur_air_jumps: int = max_air_jumps

@onready var lr_lock: bool = false
@onready var floating: bool = false

@onready var state_machine: StateMachine = $StateMachine

func _ready() -> void:
	EventBus.player_set_pos.connect(set_pos)

func _process(_delta: float) -> void:
	
	if floating:
		up_direction = Vector2(0, 1)
	else:
		up_direction = Vector2(0, -1)
	
	var hit_jump_pad = false
	var collided: bool = move_and_slide()
	if collided:
		for i in range(0, get_slide_collision_count()):
			var collider: Node = get_slide_collision(i).get_collider()
			if collider.is_in_group("jump_pad") and !hit_jump_pad and state_machine.current_state.name != "Jump":
				scale = Vector2(1, 1)
				velocity.y = -jump_pad_velocity
				hit_jump_pad = true
				state_machine.on_change_state(state_machine.current_state, "Jump")
	

func lr_movement(delta: float) -> void:
	
	if lr_lock: return
	
	var input_direction: float = Input.get_axis("left", "right")
	var player_acceleration: float = max_speed / time_to_reach_max_speed
	var player_deceleration: float = max_speed / time_to_reach_zero_speed
	
	if input_direction == 0:
		if abs(velocity.x) < player_deceleration * delta: 
			velocity.x = 0
		else: 
			velocity.x -= player_deceleration * sign(velocity.x) * delta
	else:
		velocity.x = clampf(velocity.x + player_acceleration * input_direction * delta, -max_speed, max_speed)


func apply_gravity(delta: float, sliding: bool) -> void:
	
	if floating:
		if sliding:
			velocity.y = max(velocity.y - fall_gravity * sliding_factor * delta, -max_float_gravity)
		else:
			velocity.y = max(velocity.y - fall_gravity * delta, -max_float_gravity)
		return
	
	if sliding:
		velocity.y = min(velocity.y + fall_gravity * sliding_factor * delta, max_gravity)
	else:
		velocity.y = min(velocity.y + get_gravity_value() * delta, max_gravity)


func get_gravity_value() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity


func apply_wall_jump(direction: float) -> void:
	lr_lock = true
	velocity.x = direction * wall_jump_force
	await get_tree().create_timer(0.05).timeout
	lr_lock = false


func approach_size(x: float, y: float, delta: float) -> void:
	if up_direction == Vector2(1, 0):
		scale = Vector2(1, 1)
		return
	if scale.x > 1:
		scale.x = move_toward(scale.x, x, squish_factor * delta)
		scale.y = move_toward(scale.y, y, squish_factor * delta)
	else:
		scale.x = move_toward(scale.x, x, stretch_factor * delta)
		scale.y = move_toward(scale.y, y, stretch_factor * delta)


func lock_movement(time: float) -> void:
	lr_lock = true
	await get_tree().create_timer(time).timeout
	lr_lock = false

func set_pos(p: Vector2) -> void:
	global_position = p
