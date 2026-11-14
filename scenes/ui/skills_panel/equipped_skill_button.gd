extends Button
class_name EquippedSkillButton

@export var number: int

@onready var empty: Panel = $Empty
@onready var skill_icon: TextureRect = $SkillIcon
@onready var label: Label = $Label

@onready var cooldown_ui: Control = %Cooldown
@onready var cooldown_bar: TextureProgressBar = %CooldownBar
@onready var cooldown_label: Label = %CooldownLabel
@onready var cooldown_timer: Timer = %CooldownTimer

var equipped_data: SkillData
var can_use: bool
var cooldown_tween: Tween

func _ready() -> void:
	label.text = str(number)

func equip_skill(data: SkillData) -> void:
	equipped_data = data
	empty.hide()
	skill_icon.texture = data.icon
	skill_icon.show()
	cooldown_ui.hide()
	can_use = true

func reset_skill_button() -> void:
	empty.show()
	skill_icon.hide()
	can_use = false

func start_cooldown() -> void:
	if equipped_data:
		can_use = false
		cooldown_label.text = str(equipped_data.cooldown)
		cooldown_bar.max_value = equipped_data.cooldown
		cooldown_bar.value = equipped_data.cooldown
		
		cooldown_ui.show()
		cooldown_timer.start(equipped_data.cooldown)
		
		if cooldown_tween: cooldown_tween.kill()
		cooldown_tween = create_tween()
		cooldown_tween.tween_method(_update_cooldown, equipped_data.cooldown, 0.0, equipped_data.cooldown)
		

func _update_cooldown(remaining: float) -> void:
	cooldown_bar.value = remaining
	cooldown_label.text = "%.1f" % remaining

func _on_pressed() -> void:
	if equipped_data:
		GameData.skill_slots[number - 1] = null
		equipped_data = null
		reset_skill_button()

func _on_cooldown_timer_timeout() -> void:
	can_use = true
	cooldown_ui.hide()
