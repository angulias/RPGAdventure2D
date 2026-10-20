#it for the UI
extends Node

signal on_player_created
signal on_player_health_updated(cur_health: float, max_health: float)
signal on_player_mana_updated(cur_mana: float, max_mana: float)

signal on_player_new_level(cur_exp: float, new_level: float)
signal on_player_stats_updated
