extends Camera2D

@export var player: CharacterBody2D
@export var player_size: float
@export_range(0, 1) var max_offset: float
@export_range(0, 1) var offset_speed: float

@onready var current_offset = 0

func _ready() -> void:
	position = player.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var half_screen_width: float = get_viewport_rect().size.x / (2 * zoom.x)
	var half_screen_player: float = half_screen_width - player_size / (2 * zoom.x)

	if !player.is_on_wall():
		current_offset += offset_speed * half_screen_player * sign(player.velocity.x) * delta
		current_offset = clampf(current_offset, -max_offset * half_screen_player, max_offset * half_screen_player)
		
	if player.position.x - half_screen_width < limit_left:
		current_offset = limit_left + half_screen_width - player.position.x
		current_offset = snapped(current_offset, 0.001)
		position = Vector2(limit_left + half_screen_width, player.position.y)
		return
		
	if player.position.x + half_screen_width > limit_right:
		current_offset = limit_right - half_screen_width - player.position.x
		current_offset = snapped(current_offset, 0.001)
		position = Vector2(limit_right - half_screen_width, player.position.y)
		return
	
	current_offset = snapped(current_offset, 0.001)
	position = player.position + Vector2(current_offset, 0)
	#print(position)
