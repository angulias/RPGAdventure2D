extends Node

var player: Player
var hud: HUD
var navigation: TileMapLayer

const DAMAGE_FX_SCENE = preload("uid://cj377vjqyeaip")
const DAMAGE_TEXT_SCENE = preload("uid://xmxg4repyfqd")
const NEW_LEVEL_FX_SCENE = preload("uid://drhgokovjhelf")
const DROP_ITEM_SCENE = preload("uid://ms6ia438aedt")

func create_damage_fx(pos: Vector2) -> void:
	create_fx_at_pos(DAMAGE_FX_SCENE, pos)

func create_new_level_fx(pos: Vector2) -> void:
	create_fx_at_pos(NEW_LEVEL_FX_SCENE, pos)

func create_damage_text(pos: Vector2, amount: float, radio: float = 4.0) -> void:
	var label: Label = DAMAGE_TEXT_SCENE.instantiate()
	label.text = str(amount)
	label.global_position = pos + Vector2.RIGHT.rotated(randf_range(0.0, TAU) * radio)
	get_tree().root.add_child(label)
	
	var tween = create_tween()
	tween.tween_property(label, "global_position:y", label.global_position.y - 24, 0.7)
	tween.tween_callback(label.queue_free)

func create_fx_at_pos(scene: PackedScene, pos: Vector2) -> void:
	var fx: AnimatedSprite2D = scene.instantiate()
	fx.global_position = pos
	get_tree().root.add_child(fx)
	fx.animation_finished.connect(func(): fx.queue_free())
