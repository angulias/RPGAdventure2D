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

func _input(event: InputEvent) -> void:
	if not visible: return
	
	get_tree().paused = true
	if event.is_action_pressed("ui_accept") or event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		get_viewport().set_input_as_handled()
		
		if is_typing:
			complete_line()
		else:
			next_line()

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

func complete_line() -> void:
	if tween: tween.kill()
	dialogue_label.visible_characters = -1
	is_typing = false

func next_line() -> void:
	cur_line_index += 1
	show_line()

func end_dialogue() -> void:
	get_tree().paused = false
	hide()
	cur_dialogue = null
	EventBus.on_dialogue_finished.emit()

func _on_dialogue_started(data: DialogueData) -> void:
	cur_dialogue = data
	cur_line_index = 0
	npc_icon.texture = data.npc_icon
	show()
	show_line()
