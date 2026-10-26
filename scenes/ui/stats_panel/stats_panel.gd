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


func _on_str_button_pressed() -> void:
	pass # Replace with function body.


func _on_dex_button_pressed() -> void:
	pass # Replace with function body.


func _on_int_button_pressed() -> void:
	pass # Replace with function body.
