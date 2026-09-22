extends State

@onready var player: Player = $"../.."
@onready var jump_buffer: Timer = %JumpBuffer
@onready var coyote_jump: Timer = %CoyoteJump

func state_process(delta: float) -> void:
	
	player.apply_gravity(delta, false)
	
	player.lr_movement(delta)
	
	player.approach_size(1.0, 1.0, delta)
	
	if player.is_on_wall():
		var opp_input_direction: float = Input.get_axis("right", "left")
		if opp_input_direction == sign(player.get_wall_normal().x):
			player.velocity.y *= player.sliding_factor
			state_transitioned.emit(self, "slide")
	
	if Input.is_action_just_pressed("jump"):
		if !coyote_jump.is_stopped():
			state_transitioned.emit(self, "jump")
		elif player.cur_air_jumps > 0:
			player.cur_air_jumps -= 1
			state_transitioned.emit(self, "jump")
		elif jump_buffer.is_stopped():
			jump_buffer.start()
		elif player.up_direction and player.cur_air_jumps >= 0:
			player.cur_air_jumps -= 1
			player.velocity.y = player.jump_velocity
	
	if player.is_on_floor():
		if player.up_direction == Vector2(0, -1):
			player.scale = Vector2(1.5, 0.6)
		if player.velocity.x == 0:
			state_transitioned.emit(self, "idle")
		else:
			state_transitioned.emit(self, "move")
