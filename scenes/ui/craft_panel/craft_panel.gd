extends Control
class_name CraftPanel

@export var recipes: Array[CraftData]

@onready var container: GridContainer = %Container
@onready var materials_container: VBoxContainer = %MaterialsContainer

@onready var item_icon: TextureRect = %ItemIcon
@onready var item_name: Label = %ItemName

@onready var material_1_icon: TextureRect = %Material1Icon
@onready var material_1_name: Label = %Material1Name
@onready var material_1_qty: Label = %Material1Qty

@onready var material_2_icon: TextureRect = %Material2Icon
@onready var material_2_name: Label = %Material2Name
@onready var material_2_qty: Label = %Material2Qty

@onready var amount_label: Label = %AmountLabel

var amount_selected: int = 1
var button_selected: CraftButton

func _ready() -> void:
	materials_container.hide()
	for button in container.get_children():
		button.queue_free()
	
	create_craft_recipes()

func create_craft_recipes() -> void:
	for data: CraftData in recipes:
		var btn: CraftButton = Refs.CRAFT_BUTTON_SCENE.instantiate()
		btn.pressed.connect(_on_button_pressed.bind(btn))
		container.add_child(btn)
		btn.load_data(data)

func update_material_information() -> void:
	item_icon.texture = button_selected.data.craft_item.icon
	item_name.text = button_selected.data.craft_item.name
	amount_label.text = str(amount_selected)
	
	var mat_1 = button_selected.data.craft_materials[0]
	material_1_icon.texture = mat_1.item.icon
	material_1_name.text = mat_1.item.name
	
	var req_1: int = mat_1.amount * amount_selected
	material_1_qty.text = "%s/%s" % [req_1, Inventory.count_item(mat_1.item)]
	
	var mat_2 = button_selected.data.craft_materials[1]
	material_2_icon.texture = mat_2.item.icon
	material_2_name.text = mat_2.item.name
	
	var req_2: int = mat_2.amount * amount_selected
	material_2_qty.text =  "%s/%s" % [req_2, Inventory.count_item(mat_2.item)]

func _on_button_pressed(craft_button: CraftButton) -> void:
	if not materials_container.visible:
		materials_container.show()
	
	button_selected = craft_button
	amount_selected = 1
	update_material_information()

func _on_close_button_pressed() -> void:
	EventBus.pause(false)
	hide()
	materials_container.hide()
