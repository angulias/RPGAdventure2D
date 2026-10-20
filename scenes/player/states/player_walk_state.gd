extends PlayerState
class_name PlayerWalkState

func enter_state() -> void:
	player.play_direction_anim("walk")

func process_state(delta: float) -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if input_vector == Vector2.ZERO:
		fsm.transition_to("IdleState")
		return
	
	player.update_direction(input_vector)
	player.play_direction_anim("walk")
	
	player.velocity = input_vector * player.move_speed
	player.move_and_slide()
