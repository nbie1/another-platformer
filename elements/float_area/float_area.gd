extends Area2D

func _draw() -> void:
	for child in get_children():
		if child is CollisionShape2D and child.shape is RectangleShape2D:
			draw_rect(Rect2(child.position - child.shape.size / 2, child.shape.size), Color(0.516, 0.0, 249.08, 0.75), true)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.floating = true


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		body.floating = false
