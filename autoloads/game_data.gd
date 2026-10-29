extends Node

var equipment: Dictionary[String, EquipData] = {
	"helmet": null,
	"body": null,
	"legs": null,
	"weapon": null,
	"ring": null
}

var bonus_equipment: Dictionary[String, float] = {
	"dmg": 0.0,
	"hp": 0.0,
	"mana": 0.0,
	"speed": 0.0,
	"crit": 0.0,
	"crit_dmg": 0.0
}

func apply_bonus_equip(equip_item: EquipData, equipped: bool = true) -> void:
	if not equip_item: return
	
	bonus_equipment["dmg"] += equip_item.bonus_damage if equipped else -equip_item.bonus_damage
	bonus_equipment["hp"] += equip_item.bonus_hp if equipped else -equip_item.bonus_hp
	bonus_equipment["mana"] += equip_item.bonus_mana if equipped else -equip_item.bonus_mana
	bonus_equipment["speed"] += equip_item.bonus_speed if equipped else -equip_item.bonus_speed
	bonus_equipment["crit"] += equip_item.bonus_crit if equipped else -equip_item.bonus_crit
	bonus_equipment["crit_dmg"] += equip_item.bonus_crit_dmg if equipped else -equip_item.bonus_crit_dmg
	
	Refs.player.update_total_stats()

func set_color_bonus_label(label_keys: Dictionary[String, Label]) -> void:
	var equip_bonus: Array[String] = GameData.bonus_equipment.keys()
	for key in equip_bonus:
		if label_keys[key]:
			label_keys[key].label_settings.font_color = GameData.get_color_bonus(key)

func get_color_bonus(stat: String) -> Color:
	return Color.GREEN if bonus_equipment[stat] > 0.0 else (Color.RED if bonus_equipment[stat] < 0.0 else Color.WHITE)
