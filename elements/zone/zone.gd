extends Area2D

func _draw() -> void:
	for child in get_children():
		if child is CollisionShape2D and child.shape is RectangleShape2D:
			draw_rect(Rect2(child.position - child.shape.size / 2, child.shape.size), Color(143.218, 0.0, 35.342, 0.757), true)

var tmp: Player

func _on_area_entered(_area: Area2D) -> void:
	LevelManager.redo()
