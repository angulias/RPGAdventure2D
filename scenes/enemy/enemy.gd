extends Area2D
class_name Enemy

signal on_enemy_die

@export var max_health: float = 10.0
@export var damage: float = 2.0

@export var exp_amount: float = 20.0
@export var loot: Array[LootData]

@onready var selector: Sprite2D = $Selector
@onready var health_component: HealthComponent = $HealthComponent
@onready var fsm: FiniteStateMachine = $FiniteStateMachine
@onready var anim_sprite: AnimatedSprite2D = $AnimSprite
@onready var health_bar: ProgressBar = $HealthBar

var enemy_zone: EnemyZone
var focus_decay: float = 2.0
@export var focus: bool = false

func _ready() -> void:
	health_component.setup(max_health)
	health_bar.value = 1.0

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

func drop_loot() -> void:
	for loot_drop: LootData in loot:
		if randf() >= loot_drop.drop_chance:
			continue
		
		var drop_item: DropItem = Refs.DROP_ITEM_SCENE.instantiate()
		var random_amount := randi_range(loot_drop.min_amount, loot_drop.amount)
		
		var away_direction: Vector2 = (global_position - Refs.player.global_position).normalized()
		var random_offset: Vector2 = Vector2(randf_range(-8.0, 8.0), randf_range(-8.0, 8.0))
		var drop_pos: Vector2 = global_position + away_direction * 15 + random_offset
		
		drop_item.load_item(loot_drop, random_amount)
		drop_item.global_position = drop_pos
		get_tree().root.call_deferred("add_child", drop_item)
		
		on_enemy_die.emit()

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


func _on_health_component_on_health_changed(cur_health: float) -> void:
	health_bar.value = cur_health / max_health


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		Refs.player.selected_enemy = self


func _on_health_component_on_dead() -> void:
	drop_loot()
	Refs.player.add_exp(exp_amount)
	queue_free()
