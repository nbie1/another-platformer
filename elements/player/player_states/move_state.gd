extends State

@onready var player: Player = $"../.."
@onready var jump_buffer: Timer = %JumpBuffer
@onready var coyote_jump: Timer = %CoyoteJump

func state_enter() -> void:
	player.cur_air_jumps = player.max_air_jumps
	coyote_jump.stop()

func state_process(delta: float) -> void:
	
	player.apply_gravity(delta, false)
	
	player.lr_movement(delta)
	
	player.approach_size(1.0, 1.0, delta)
	
	if player.up_direction == Vector2(0, 1):
		state_transitioned.emit(self, "fall")
	
	if player.velocity.x == 0:
		state_transitioned.emit(self, "idle")
	
	if Input.is_action_just_pressed("jump"):
		state_transitioned.emit(self, "jump")
	if !jump_buffer.is_stopped():
		jump_buffer.stop()
		state_transitioned.emit(self, "jump")
		
	if !player.is_on_floor():
		coyote_jump.start()
		state_transitioned.emit(self, "fall")
