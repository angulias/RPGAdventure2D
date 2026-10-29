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

var strength_value: int = 0
var dexterity_value: int = 0
var intelligence_value: int = 0

var cur_exp: float
var next_lvl_exp: float

var cur_lvl: int = 1
var cur_points: int = 0

var cur_mana: float
var last_direction: String = "down"

var total_max_health: float
var total_max_mana: float
var total_move_speed: float
var total_damage: float
var total_crit_chance: float
var total_crit_damage: float

func _process(delta: float) -> void:
	if fsm.cur_state:
		fsm.cur_state.process_state(delta)

func setup() -> void:
	update_total_stats()
	reset_health()
	reset_mana()
	next_lvl_exp = base_exp

func reset_health() -> void:
	health_component.setup(total_max_health)
	EventBus.on_player_health_updated.emit(total_max_health, total_max_health)

func reset_mana() -> void:
	cur_mana = total_max_mana
	EventBus.on_player_mana_updated.emit(total_max_mana, total_max_mana)

func use_mana(value: float) -> void:
	cur_mana -= value
	cur_mana = max(cur_mana, 0)
	EventBus.on_player_mana_updated.emit(cur_mana, total_max_mana)

func add_mana(value: float) -> void:
	cur_mana += value
	cur_mana = min(cur_mana, total_max_mana)
	EventBus.on_player_mana_updated.emit(cur_mana, total_max_mana)

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

func upgrade_stat(stat_name: String) -> void:
	if cur_points <= 0: return
	
	cur_points -= 1
	match stat_name:
		"STR":
			strength_value += 1
			damage += 1.5
			total_damage += 1.5
			max_health += 3.0
			total_max_health += 3.0
			reset_health()
		"DEX":
			dexterity_value += 1
			move_speed += 2.0
			total_move_speed += 2.0
			crit_chance += 2.0
			total_crit_chance += 2.0
		"INT":
			intelligence_value += 1
			max_mana += 15.0
			total_max_mana += 15.0
			crit_damage += 5.0
			total_crit_damage += 5.0
			reset_mana()
	
	EventBus.on_player_stats_updated.emit()

func update_total_stats() -> void:
	total_max_health = max(max_health + GameData.bonus_equipment["hp"], 1)
	total_max_mana = max(max_mana + GameData.bonus_equipment["mana"], 1)
	total_move_speed = max(move_speed + GameData.bonus_equipment["speed"], 30)
	total_damage = max(damage + GameData.bonus_equipment["dmg"], 1)
	total_crit_chance = max(crit_chance + GameData.bonus_equipment["crit"], 0)
	total_crit_damage = max(crit_damage + GameData.bonus_equipment["crit_dmg"], 0)
	
	health_component.change_max_health(total_max_health)
	EventBus.on_player_mana_updated.emit(cur_mana, total_max_mana)

func get_damage(skill_dmg: float = 0.0) -> float:
	var total_dmg = total_damage + skill_dmg
	
	# Check our critical attack
	if randf() * 100 <= total_crit_chance:
		total_dmg *= (1.0 + (total_crit_damage / 100.0))
	
	return total_dmg

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


func _on_health_component_on_dead() -> void:
	queue_free()

func _on_health_component_on_health_changed(cur_health: float) -> void:
	EventBus.on_player_health_updated.emit(cur_health, total_max_health)
