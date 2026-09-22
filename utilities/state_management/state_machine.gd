class_name StateMachine
extends Node

@export var initial_state: State
@export var disabled: bool = true

var current_state: State
var states: Dictionary = {}

func _ready() -> void:
	
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_transitioned.connect(on_change_state)
	
	if initial_state:
		current_state = initial_state
		if !disabled:
			initial_state.state_enter()

func _process(delta: float) -> void:
	if disabled: return
	if current_state:
		current_state.state_process(delta)
		
func _physics_process(delta: float) -> void:
	if disabled: return
	if current_state:
		current_state.state_physics_process(delta)

func on_change_state(state: State, new_state_name: String) -> void:
	
	if disabled: return
	if current_state != state: 
		return
		
	var new_state: State = states.get(new_state_name.to_lower())
	if new_state == null: 
		return

	if current_state:
		current_state.state_exit()

	new_state.state_enter()
	
	current_state = new_state
