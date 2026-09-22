extends State

@onready var player: Player = $"../.."
@onready var jump_buffer: Timer = %JumpBuffer
@onready var coyote_jump: Timer = %CoyoteJump

func state_enter() -> void:
	player.cur_air_jumps = player.max_air_jumps
	coyote_jump.stop()

func state_process(delta: float) -> void:
	
	player.apply_gravity(delta, false)
	
	player.approach_size(1.0, 1.0, delta)

	if player.velocity.y < 0:
		if player.up_direction == Vector2(0, 1) and !player.is_on_floor():
			state_transitioned.emit(self, "fall")
		elif player.up_direction == Vector2(0, -1):
			state_transitioned.emit(self, "jump")
	if Input.is_action_just_pressed("jump"):
		state_transitioned.emit(self, "jump")
	if !jump_buffer.is_stopped():
		jump_buffer.stop()
		player.stop_particle()
		state_transitioned.emit(self, "jump")
	if Input.is_action_pressed("left") != Input.is_action_just_pressed("right"):
		state_transitioned.emit(self, "move")
