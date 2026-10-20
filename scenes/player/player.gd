extends CharacterBody2D
class_name Player

@export_group("Stats")
@export var max_health: float = 10.0
@export var max_mana: float = 10.0
@export var move_speed: float = 60.0
@export var damage: float = 5.0
@export var crit_chance: float = 0.0
@export var crit_damage: float = 0.0

@export_group("Exp")
@export var base_exp: float = 145.0
@export var exp_multiplier: float = 1.3

@onready var anim_sprit: AnimatedSprite2D = $AnimSprit
@onready var health_component: HealthComponent = $HealthComponent
@onready var enemy_area: Area2D = %EnemyAttackArea
@onready var weapon: Node2D = $Weapon
@onready var fsm: FiniteStateMachine = $FiniteStateMachine

@onready var attack_positions: Dictionary = {
	"down": %Down,
	"up": %Up,
	"right": %Right,
	"left": %Left
}

var cur_exp: float
var next_lvl_exp: float

var cur_lvl: int = 1
var cur_points: int = 0

var cur_mana: float
var last_direction: String = "down"

func _process(delta: float) -> void:
	if fsm.cur_state:
		fsm.cur_state.process_state(delta)

func setup() -> void:
	reset_health()
	reset_mana()
	next_lvl_exp = base_exp

func reset_health() -> void:
	health_component.setup(max_health)
	EventBus.on_player_health_updated.emit(max_health, max_health)

func reset_mana() -> void:
	cur_mana = max_mana
	EventBus.on_player_mana_updated.emit(max_mana, max_mana)

func use_mana(value: float) -> void:
	cur_mana -= value
	cur_mana = max(cur_mana, 0)
	EventBus.on_player_mana_updated.emit(cur_mana, max_mana)

func add_exp(value: float) -> void:
	cur_exp += value
	while cur_exp >= next_lvl_exp:
		level_up()
	
	EventBus.on_player_new_level.emit(cur_exp, next_lvl_exp)

func level_up() -> void:
	cur_exp -= next_lvl_exp
	cur_lvl += 1
	cur_points += 4
	next_lvl_exp *= exp_multiplier
	EventBus.on_player_stats_updated.emit()

func enable_weapon_collision(value: bool) -> void:
	enemy_area.monitoring = value

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
