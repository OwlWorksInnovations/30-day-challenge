extends CharacterBody2D

var cannon_speed := 150.0 
var player_node: Node2D = null
var is_launched := false

const DIRECTION_MAP = {
	0: Vector2(-1, 1),
	1: Vector2(0, 1),
	2: Vector2(-1, 0),
	3: Vector2(1, 0),
	4: Vector2(1, 1),
	5: Vector2(0, -1),
	6: Vector2(1, -1),
	7: Vector2(-1, -1)
}

const REPLACEMENT_MAP = {
	Vector2i(0, 1): Vector2i(0, 0)
}

func _ready() -> void:
	player_node = get_tree().get_first_node_in_group("player")
	
	if player_node:
		add_collision_exception_with(player_node)
		
		var sprite = player_node.get_node("AnimatedSprite2D")
		var frame = sprite.frame
		
		if DIRECTION_MAP.has(frame):
			velocity = DIRECTION_MAP[frame].normalized() * cannon_speed
			is_launched = true

func _physics_process(delta: float) -> void:
	if is_launched:
		var collision = move_and_collide(velocity * delta)
		if collision:
			handle_tile_collision(collision)

func handle_tile_collision(collision: KinematicCollision2D) -> void:
	var collider = collision.get_collider()
	
	if collider is TileMapLayer:
		var impact_point = collision.get_position() - collision.get_normal() * 4
		var tile_pos = collider.local_to_map(collider.to_local(impact_point))
		var current_atlas_coords = collider.get_cell_atlas_coords(tile_pos)
		
		if REPLACEMENT_MAP.has(current_atlas_coords):
			var new_tile = REPLACEMENT_MAP[current_atlas_coords]
			collider.set_cell(tile_pos, 0, new_tile)
			
	queue_free()
