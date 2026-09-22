class_name State
extends Node

@warning_ignore("unused_signal")
signal state_transitioned(cur_state: State, new_state_name: String)

func state_enter() -> void:
	pass
	
func state_exit() -> void:
	pass
	
@warning_ignore("unused_parameter")
func state_process(delta: float) -> void:
	pass
	
@warning_ignore("unused_parameter")
func state_physics_process(delta: float) -> void:
	pass
