extends Resource
class_name LootData

@export var item: ItemData
@export var min_amount: int = 1
@export var max_amount: int

@export_range(0.0, 1.0, 0.01)
var drop_chance: float = 1.0
