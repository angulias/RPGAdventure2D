extends Area2D
class_name Enemy

signal on_enemy_die

@export var max_health: float = 10.0
@export var damage: float = 2.0

@export var exp_amount: float = 20.0

@onready var selector: Sprite2D = $Selector
@onready var health_component: HealthComponent = $HealthComponent
@onready var fsm: FiniteStateMachine = $FiniteStateMachine
@onready var anim_sprite: AnimatedSprite2D = $AnimSprite

var enemy_zone: EnemyZone
var focus_decay: float = 2.0
@export var focus: bool = false

func _ready() -> void:
	health_component.setup(max_health)

func _process(delta: float) -> void:
	if fsm.cur_state:
		fsm.cur_state.process_state(delta)

func update_animation(dir: Vector2) -> void:
	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			anim_sprite.play("move_right")
		else: anim_sprite.play("move_left")
	else:
		if dir.y > 0:
			anim_sprite.play("move_down")
		else: anim_sprite.play("move_up")

func select_enemy() -> void:
	selector.show()

func deselect_enemy() -> void:
	selector.hide()


func _on_detect_area_body_entered(_body: Node2D) -> void:
	fsm.transition_to("FollowState")
	focus = true


func _on_detect_area_body_exited(_body: Node2D) -> void:
	focus = false
	await get_tree().create_timer(focus_decay, false).timeout
	if not focus:
		fsm.transition_to("WanderState")
