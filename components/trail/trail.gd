extends Line2D

@export var length: int = 50

var point = Vector2()

#func _ready() -> void:
	#global_rotation = 0
	#global_position = Vector2(0, 0)

func _process(_delta: float) -> void:
	global_position = Vector2(0, 0)
	
	var follower: Node2D = get_parent()
	point = follower.global_position
	
	add_point(point)
	#print("#", point)
	
	while get_point_count() > length:
		#print(",", get_point_position(0))
		remove_point(0)
