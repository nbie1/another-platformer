extends State

@onready var player: Player = $"../.."
@onready var jump_buffer: Timer = %JumpBuffer

func state_enter() -> void:
	player.cur_air_jumps = 0

func state_process(delta: float) -> void:
	
	player.apply_gravity(delta, true)
	
	player.approach_size(1.0, 1.0, delta)
	
	var opp_input_direction: float = Input.get_axis("right", "left")
	
	if Input.is_action_just_pressed("jump"):
		player.apply_wall_jump(opp_input_direction)
		state_transitioned.emit(self, "jump")
	
	if !player.is_on_wall() and !player.lr_lock:
		state_transitioned.emit(self, "fall")

	if opp_input_direction != sign(player.get_wall_normal().x):
		state_transitioned.emit(self, "fall")
	
	if player.is_on_floor():
		if !jump_buffer.is_stopped():
			state_transitioned.emit(self, "jump")
		elif player.velocity.x == 0:
			state_transitioned.emit(self, "idle")
		else:
			state_transitioned.emit(self, "move")
			
