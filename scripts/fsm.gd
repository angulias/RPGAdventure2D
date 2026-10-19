extends Node
class_name FiniteStateMachine

signal on_state_transitioned(state_name: String)

@export var initial_state: NodePath

var cur_state: State

func _ready() -> void:
	await owner.ready
	
	for state: State in get_children():
		state.fsm = self
	
	cur_state = get_node(initial_state)
	cur_state.enter_state()

func transition_to(state_name: String) -> void:
	if not has_node(state_name):
		return
	
	cur_state.exit_state()
	cur_state = get_node(state_name)
	cur_state.enter_state()
	on_state_transitioned.emit(cur_state.name)
