extends Node2D
class_name Town

@export var player_scene: PackedScene

func _ready() -> void:
	EventBus.on_inventory_use_item.connect(_on_inventory_use_item)
	
	create_player()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		Refs.player.use_mana(1.0)
		Refs.player.add_exp(60)

func create_player() -> void:
	var player: Player = player_scene.instantiate()
	add_child(player)
	player.setup()
	Refs.player = player
	EventBus.on_player_created.emit()

func _on_inventory_use_item(item: ItemData) -> void:
	match item.id:
		"hp_potion": Refs.player.health_component.heal(item.value)
		"mana_potion": Refs.player.add_mana(item.value)
