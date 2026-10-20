extends CharacterBody2D
class_name Player

@export_group("Stats")
@export var max_health: float = 10.0
@export var max_mana: float = 10.0
@export var move_speed: float = 60.0
@export var damage: float = 5.0
@export var crit_chance: float = 0.0
@export var crit_damage: float = 0.0

@onready var anim_sprit: AnimatedSprite2D = $AnimSprit
@onready var fsm: FiniteStateMachine = $FiniteStateMachine

var last_direction: String = "down"

func _process(delta: float) -> void:
	if fsm.cur_state:
		fsm.cur_state.process_state(delta)

func is_moving() -> bool:
	var move_input = ["move_down", "move_up", "move_right", "move_left"]
	
	for input in move_input:
		if Input.is_action_pressed(input):
			return true
	return false

func update_direction(input_vector: Vector2) -> void:
	if input_vector == Vector2.ZERO: return
	
	if abs(input_vector.x) > abs(input_vector.y):
		last_direction = "right" if input_vector.x > 0 else "left"
	else:
		last_direction = "down" if input_vector.y > 0 else "up"

func play_direction_anim(anim_name: String) -> void:
	anim_sprit.play("%s_%s" % [anim_name, last_direction])
