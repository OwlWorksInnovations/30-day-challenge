extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var fire_rate: float = 1.0
const CANNON_BALL_PLR = preload("uid://c7e8qtiauda4s")
var playerSpeed: float = 100.0
var last_direction: Vector2 = Vector2.UP
var shoot_timer: float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Movement
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction.length() > 0:
		velocity = direction.normalized() * playerSpeed
		last_direction = direction.normalized()
		update_direction(direction)
	else:
		velocity = Vector2.ZERO
		
	# Shooting
	shoot_timer += delta
	if shoot_timer >= fire_rate:
		if Input.is_action_just_pressed("shoot"):
			shoot_cannon()
			shoot_timer = 0.0
	
	move_and_slide()

# Updates the sprite direction
func update_direction(direction: Vector2):
	if direction == Vector2.ZERO:
		return
		
	var angle = rad_to_deg(direction.angle())
	if angle > -112.5 and angle <= -67.5:
		sprite.frame = 5
	elif angle > -67.5 and angle <= -22.5:
		sprite.frame = 4
	elif angle > -22.5 and angle <= 22.5:
		sprite.frame = 3
	elif angle > 22.5 and angle <= 67.5:
		sprite.frame = 2
	elif angle > 67.5 and angle <= 112.5:
		sprite.frame = 1
	elif angle > 112.5 and angle <= 157.5:
		sprite.frame = 0
	elif angle > 157.5 or angle <= -157.5:
		sprite.frame = 7
	elif angle > -157.5 and angle <= -112.5:
		sprite.frame = 6

# Shoot cannon
func shoot_cannon():
	var cannon_ball_plr = CANNON_BALL_PLR.instantiate()
	cannon_ball_plr.global_position = self.global_position
	get_parent().add_child(cannon_ball_plr) 

# Load next level
func _on_level_loader_body_entered(body: Node2D) -> void:
	if body == self:
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/world_two.tscn")
