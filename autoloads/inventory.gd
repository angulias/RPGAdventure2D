extends Node

signal on_inventory_changed
signal on_equipment_changed

const INVENTORY_SIZE: int = 30

var inventory: Array[SlotData]

func _ready() -> void:
	inventory.clear()
	inventory.resize(INVENTORY_SIZE)

func get_empty_slot_indexes() -> Array[int]:
	var empty: Array[int] = []
	
	for i in inventory.size():
		if inventory[i] == null:
			empty.append(i)
	
	return empty

func find_item_indexes(item: ItemData, with_space: bool = false) -> Array[int]:
	var found: Array[int] = []
	
	for i in inventory.size():
		var slot = inventory[i]
		if slot and slot.item == item:
			if with_space:
				if slot.quantity < item.max_stack:
					found.append(i)
			else:
				found.append(i)
	
	return found

func add_item(item: ItemData, amount: int = 1) -> void:
	if not item: return
	
	var remaining = amount
	
	if item.max_stack > 1:
		for index in find_item_indexes(item, true):
			if remaining <= 0:
				break
			
			var slot = inventory[index]
			var space = item.max_stack - slot.quantity
			var to_give = min(space, remaining)
			
			slot.quantity += to_give
			remaining -= to_give
	
	if remaining > 0:
		for index in get_empty_slot_indexes():
			if remaining <= 0:
				break
			
			var to_give = min(item.max_stack, remaining)
			inventory[index] = SlotData.new(item, to_give)
			remaining -= to_give
	
	var added = amount - remaining
	if added > 0:
		on_inventory_changed.emit()
		

func swap_slots(from_index: int, to_index: int) -> void:
	if from_index < 0 or from_index >= inventory.size():
		return
	if to_index < 0 or to_index >= inventory.size():
		return
	
	var temp := inventory[from_index]
	inventory[from_index] = inventory[to_index]
	inventory[to_index] = temp
	on_inventory_changed.emit()

func merge_slots(from_index: int, to_index: int) -> void:
	var from_slot: SlotData = get_slot(from_index)
	var to_slot: SlotData = get_slot(to_index)
	
	if not from_slot or not to_slot:
		return
	if from_slot.item != to_slot.item:
		return
	
	var item = from_slot.item
	if item.max_stack <= 1:
		return
	
	var space = item.max_stack - to_slot.quantity
	var to_move = min(space, from_slot.quantity)
	
	to_slot.quantity += to_move
	from_slot.quantity -= to_move
	
	if from_slot.quantity == 0:
		inventory[from_index] = null
	elif space <= 0:
		swap_slots(from_index, to_index)
	
	on_inventory_changed.emit()

func get_slot(index: int) -> SlotData:
	if index >= 0 and index < inventory.size():
		return inventory[index]
	return null

func get_slot_item(index: int) -> ItemData:
	var slot = get_slot(index)
	if slot:
		return slot.item
	return null
