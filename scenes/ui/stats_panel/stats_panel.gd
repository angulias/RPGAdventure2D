extends PanelContainer
class_name StatsPanel

@onready var dmg_label: Label = %DMGLabel
@onready var hp_label: Label = %HPLabel
@onready var vel_label: Label = %VelLabel
@onready var mana_label: Label = %ManaLabel
@onready var crit_label: Label = %CritLabel
@onready var crit_dmg_label: Label = %CritDMGLabel

@onready var cur_level_label: Label = %CurLevelLabel
@onready var cur_points_label: Label = %CurPointsLabel

@onready var str_points_label: Label = %STRPointsLabel
@onready var dex_points_label: Label = %DEXPointsLabel
@onready var int_points_label: Label = %INTPointsLabel

func _ready() -> void:
	EventBus.on_player_created.connect(_on_player_created)
	EventBus.on_player_stats_updated.connect(_on_player_stats_updated)

func update_stats() -> void:
	if not is_instance_valid(Refs.player):
		return
	dmg_label.text = "DMG: %s" % str(Refs.player.damage)
	hp_label.text = "HP: %s" % str(Refs.player.max_health)
	vel_label.text = "VEL: %s" % str(Refs.player.move_speed)
	mana_label.text = "Mana: %s" % str(Refs.player.max_mana)
	crit_label.text = "CRIT: %s" % str(Refs.player.crit_chance)
	crit_dmg_label.text = "C. DMG: %s" % str(Refs.player.crit_damage)
	
	cur_level_label.text = "Level: %s" % str(Refs.player.cur_lvl)
	cur_points_label.text = "Points: %s" % str(Refs.player.cur_points)
	
	str_points_label.text = str(Refs.player.strength_value)
	dex_points_label.text = str(Refs.player.dexterity_value)
	int_points_label.text = str(Refs.player.intelligence_value)

func _on_player_created() -> void:
	update_stats()

func _on_player_stats_updated() -> void:
	update_stats()

func _on_str_button_pressed() -> void:
	Refs.player.upgrade_stat("STR")


func _on_dex_button_pressed() -> void:
	Refs.player.upgrade_stat("DEX")


func _on_int_button_pressed() -> void:
	Refs.player.upgrade_stat("INT")
