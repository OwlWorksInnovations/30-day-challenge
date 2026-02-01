extends CharacterBody2D

var cannon_speed := 150.0
var player_node: Node2D = null
var is_launched := false

# Updated to match your new player frame logic
# 0: Right, 1: Left, 2: Up, 3: Down
const DIRECTION_MAP = {
	0: Vector2(1, 0), # Right
	1: Vector2(-1, 0), # Left
	2: Vector2(0, -1), # Up
	3: Vector2(0, 1) # Down
}

const REPLACEMENT_MAP = {
	Vector2i(0, 3): Vector2i(1, 3),
	Vector2i(1, 3): Vector2i(2, 3),
	Vector2i(2, 3): Vector2i(0, 0)
}

func _ready() -> void:
	# Find the player in the "player" group
	player_node = get_tree().get_first_node_in_group("player")
	
	if player_node:
		# Don't hit the player who shot it
		add_collision_exception_with(player_node)
		
		var sprite = player_node.get_node("AnimatedSprite2D")
		var frame = sprite.frame
		
		# Set velocity based on the frame the player was in
		if DIRECTION_MAP.has(frame):
			velocity = DIRECTION_MAP[frame] * cannon_speed
			is_launched = true

func _physics_process(delta: float) -> void:
	if is_launched:
		var collision = move_and_collide(velocity * delta)
		if collision:
			handle_tile_collision(collision)

func handle_tile_collision(collision: KinematicCollision2D) -> void:
	var collider = collision.get_collider()
	
	if collider is TileMapLayer:
		# Shift the impact point slightly inward to ensure we hit the right tile
		var impact_point = collision.get_position() - collision.get_normal() * 4
		var tile_pos = collider.local_to_map(collider.to_local(impact_point))
		var current_atlas_coords = collider.get_cell_atlas_coords(tile_pos)
		
		# Check if the tile hit is one that should be replaced (e.g., breaking crates)
		if REPLACEMENT_MAP.has(current_atlas_coords):
			var new_tile = REPLACEMENT_MAP[current_atlas_coords]
			collider.set_cell(tile_pos, 0, new_tile)
	
	if collider.is_in_group("enemy"):
		SignalBus.enemy_hit.emit()
			
	# Destroy the cannonball on any impact
	queue_free()
