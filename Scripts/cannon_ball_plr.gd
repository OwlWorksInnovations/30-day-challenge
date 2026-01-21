extends StaticBody2D

var cannon_speed := 150.0 
var player_node: Node2D = null
var velocity := Vector2.ZERO
var is_launched := false

# Mapping frames to direction vectors
const DIRECTION_MAP = {
	0: Vector2(-1, 1),  # Down-Left
	1: Vector2(0, 1),   # Down
	2: Vector2(-1, 0),  # Left
	3: Vector2(1, 0),   # Right
	4: Vector2(1, 1),   # Down-Right
	5: Vector2(0, -1),  # Up
	6: Vector2(1, -1),  # Up-Right
	7: Vector2(-1, -1)  # Up-Left
}

func _ready() -> void:
	player_node = get_tree().get_first_node_in_group("player")
	
	if player_node:
		var sprite = player_node.get_node("AnimatedSprite2D")
		var frame = sprite.frame
		
		if DIRECTION_MAP.has(frame):
			velocity = DIRECTION_MAP[frame].normalized()
			is_launched = true

func _physics_process(delta: float) -> void:
	if is_launched:
		apply_movement(delta)

func apply_movement(delta: float) -> void:
	position += velocity * cannon_speed * delta
