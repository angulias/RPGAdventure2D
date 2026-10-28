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
