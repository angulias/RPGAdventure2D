extends Node
class_name HealthComponent

signal on_health_changed(cur_health: float)
signal on_dead

var max_health: float
var cur_health: float

func setup(value: float) -> void:
	max_health = value
	cur_health = value

func take_damage(value: float) -> void:
	if cur_health <= 0:
		return
	
	cur_health = max(cur_health - value, 0)
	on_health_changed.emit(cur_health)
	
	if cur_health <= 0:
		on_dead.emit()

func heal(value: float) -> void:
	cur_health += value
	cur_health = min(cur_health, max_health)
	on_health_changed.emit(cur_health)
