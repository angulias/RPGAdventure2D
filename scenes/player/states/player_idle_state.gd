extends PlayerState
class_name PlayerIdleState

func enter_state() -> void:
	player.play_direction_anim("idle")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		fsm.transition_to("AttackState")
		return
	
	if player.is_moving():
		fsm.transition_to("WalkState")
