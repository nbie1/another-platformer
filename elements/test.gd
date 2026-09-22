extends Node

func _ready() -> void:
	Global.cur_level = "debug"
	print(Global.cur_level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug"):
		print("Added debug line")
		
