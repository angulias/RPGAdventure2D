extends Node2D
class_name Town

@export var player_scene: PackedScene
@export var testing: bool = false

@onready var navigation: TileMapLayer = %Navigation

func _ready() -> void:
	EventBus.on_inventory_use_item.connect(_on_inventory_use_item)
	Refs.navigation = navigation
	if testing: setup_test()
	
	create_player()

func setup_test() -> void:
	GameData.coins = 500.0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and testing:
		#Refs.player.use_mana(1.0)
		Refs.player.add_exp(60)
		return

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
