extends PanelContainer
class_name EquipmentPanel

@onready var slots: Array[EquipmentSlot] = [
	%HelmetSlot,
	%WeaponSlot,
	%BodySlot,
	%LegsSlot,
	%RingSlot
]

@onready var bonus_dmg: Label = %BonusDmg
@onready var bonus_hp: Label = %BonusHP
@onready var bonus_mana: Label = %BonusMana
@onready var bonus_vel: Label = %BonusVel
@onready var bonus_crit: Label = %BonusCrit
@onready var bonus_c_dmg: Label = %BonusCDmg

func _ready() -> void:
	Inventory.on_equipment_changed.connect(_on_equipment_changed)
	for slot: EquipmentSlot in slots:
		slot.pressed.connect(_on_slot_pressed.bind(slot))
	
	EventBus.on_player_created.connect(_on_player_created)

func update_bonus_equip() -> void:
	bonus_dmg.text = "%d" % GameData.bonus_equipment["dmg"]
	bonus_hp.text = "%d" % GameData.bonus_equipment["hp"]
	bonus_mana.text = "%d" % GameData.bonus_equipment["mana"]
	bonus_vel.text = "%d" % GameData.bonus_equipment["speed"]
	bonus_crit.text = "%d" % GameData.bonus_equipment["crit"]
	bonus_c_dmg.text = "%d" % GameData.bonus_equipment["crit_dmg"]

func _on_player_created() -> void:
	update_bonus_equip()

func _on_equipment_changed() -> void:
	var items: Array[EquipData] = GameData.equipment.values()
	for i in slots.size():
		slots[i].load_data(items[i])
	
	update_bonus_equip()

func _on_slot_pressed(slot: EquipmentSlot) -> void:
	Inventory.unequip_item(slot.equip_type)
