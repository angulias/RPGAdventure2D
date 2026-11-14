extends Control
class_name DialoguePanel

@onready var npc_icon: TextureRect = $NPCIcon
@onready var dialogue_label: Label = %DialogueLabel

var cur_dialogue: DialogueData
var cur_line_index: int = 0
var typing_speed: float = 0.03
var is_typing: bool
var tween: Tween

func _ready() -> void:
	hide()
	EventBus.on_dialogue_started.connect(_on_dialogue_started)

func show_line() -> void:
	if cur_line_index >= cur_dialogue.line.size():
		end_dialogue()
		return
	
	var line: String = cur_dialogue.line[cur_line_index]
	dialogue_label.text = cur_dialogue.npc_name + ":\n" + line
	
	dialogue_label.visible_characters = 0
	is_typing = true
	
	if tween: tween.kill()
	tween = create_tween()
	
	var duration = dialogue_label.text.length() * typing_speed
	tween.tween_property(dialogue_label, "visible_characters", dialogue_label.text.length(), duration)
	tween.finished.connect(func(): is_typing = false)

func end_dialogue() -> void:
	hide()
	cur_dialogue = null
	EventBus.on_dialogue_finished.emit()

func _on_dialogue_started(data: DialogueData) -> void:
	cur_dialogue = data
	cur_line_index = 0
	npc_icon.texture = data.npc_icon
	show()
	show_line()
