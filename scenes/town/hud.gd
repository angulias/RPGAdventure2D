extends CanvasLayer
class_name HUD

@onready var health_bar: ProgressBar = $HealthBar
@onready var mana_bar: ProgressBar = $ManaBar
@onready var exp_bar: ProgressBar = $EXPBar

@onready var health_label: Label = %HealthLabel
@onready var mana_label: Label = %ManaLabel

@onready var equipment_panel: EquipmentPanel = %EquipmentPanel
@onready var inventory_panel: InventoryPanel = %InventoryPanel
@onready var stats_panel: StatsPanel = %StatsPanel
@onready var skills_panel: SkillsPanel = %SkillsPanel

@onready var grabbed_slot: InventorySlot = $GrabbedSlot

func _ready() -> void:
	EventBus.on_player_health_updated.connect(_on_player_health_updated)
	EventBus.on_player_mana_updated.connect(_on_player_mana_updated)
	EventBus.on_player_new_level.connect(_on_player_new_level)
	disable_all_button_focus(self)

func disable_all_button_focus(node: Node) -> void:
	if node is Button:
		node.focus_mode = Control.FOCUS_NONE
	for child in node.get_children():
		disable_all_button_focus(child)

func _on_equipement_button_pressed() -> void:
	equipment_panel.visible = not equipment_panel.visible


func _on_inventory_button_pressed() -> void:
	inventory_panel.visible = not inventory_panel.visible


func _on_stats_button_pressed() -> void:
	stats_panel.visible = not stats_panel.visible


func _on_skills_button_pressed() -> void:
	skills_panel.visible = not skills_panel.visible

func _on_player_health_updated(cur_health: float, max_health: float) -> void:
	health_bar.value = cur_health / max_health
	health_label.text = "%d / %d" % [cur_health, max_health]

func _on_player_mana_updated(cur_health: float, max_health: float) -> void:
	mana_bar.value = cur_health / max_health
	mana_label.text = "%d / %d" % [cur_health, max_health]

func _on_player_new_level(cur: float, new_level: float) -> void:
	exp_bar.value = cur / new_level
