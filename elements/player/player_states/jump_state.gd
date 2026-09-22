extends State

@onready var player: Player = $"../.."
@onready var jump_buffer: Timer = %JumpBuffer

func state_enter() -> void:
	if player.velocity.y >= player.jump_velocity:
		player.velocity.y = player.jump_velocity
	player.scale = Vector2(0.7, 1.4)
	
func state_process(delta: float) -> void:
	player.apply_gravity(delta, false)
	
	player.lr_movement(delta)
	
	player.approach_size(1.0, 1.0, delta)
	
	var opp_input_direction: float = Input.get_axis("right", "left")
	
	if player.up_direction == Vector2(1, 0):
		state_transitioned.emit(self, "fall")
	
	if Input.is_action_just_pressed("jump"):
		if player.is_on_wall() and opp_input_direction == sign(player.get_wall_normal().x):
			player.apply_wall_jump(opp_input_direction)
			state_transitioned.emit(self, "jump")
		if player.cur_air_jumps > 0:
			player.cur_air_jumps -= 1
			state_transitioned.emit(self, "jump")
		elif jump_buffer.is_stopped():
			jump_buffer.start()
			
	if player.is_on_wall() and player.velocity.y > 0:
		if opp_input_direction == sign(player.get_wall_normal().x):
			state_transitioned.emit(self, "slide")
	
	if player.is_on_floor() and player.up_direction == Vector2(0, -1):
		if player.velocity.x != 0:
			state_transitioned.emit(self, "idle")
		else:
			state_transitioned.emit(self, "move")
	
	if player.velocity.y > 0:
		state_transitioned.emit(self, "fall")
