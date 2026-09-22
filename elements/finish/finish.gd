extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _draw() -> void:
	var tmp: CircleShape2D = collision_shape_2d.shape
	draw_circle(collision_shape_2d.position, tmp.radius, Color(0.462, 1.0, 0.427, 1.0))


var start: float

func _ready() -> void:
	start = Time.get_ticks_msec()
	print("#", start)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		Engine.time_scale = 0.0
		var end: float = Time.get_ticks_msec()
		print(end - start)
