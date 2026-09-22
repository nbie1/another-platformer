extends Node

func redo() -> void:
	EventBus.player_set_pos.emit(Global.level_start_pos.get(Global.cur_level))
