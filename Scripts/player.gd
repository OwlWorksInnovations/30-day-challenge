extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var fire_rate: float = 0.5
const CANNON_BALL_PLR = preload("uid://c7e8qtiauda4s")
const HEALTH = preload("uid://oh335xfxuov7")

var health_instance: Control
var sprite1: AnimatedSprite2D
var sprite2: AnimatedSprite2D
var sprite3: AnimatedSprite2D

var playerSpeed: float = 100.0
var last_direction: Vector2 = Vector2.UP
var shoot_timer: float = 0.0
var health: int = 3

func _ready() -> void:
	health_instance = HEALTH.instantiate()
	get_tree().root.add_child.call_deferred(health_instance)
	
	sprite1 = health_instance.get_node("1")
	sprite2 = health_instance.get_node("2")
	sprite3 = health_instance.get_node("3")
	
	sprite1.frame = 0
	sprite2.frame = 0
	sprite3.frame = 0
	
	SignalBus.player_hit.connect(update_health)

func _process(delta: float) -> void:
	# Get raw inputs
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = Vector2.ZERO

	# Diagonal Prevention Logic:
	# If there is input, we pick the dominant axis
	if input_dir.length() > 0:
		if abs(input_dir.x) >= abs(input_dir.y):
			direction.x = sign(input_dir.x)
		else:
			direction.y = sign(input_dir.y)

	# Movement Execution
	if direction != Vector2.ZERO:
		velocity = direction * playerSpeed
		last_direction = direction
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

func update_direction(direction: Vector2):
	if direction.x > 0:
		sprite.frame = 0 # Right
	elif direction.x < 0:
		sprite.frame = 1 # Left
	elif direction.y > 0:
		sprite.frame = 2 # Down
	elif direction.y < 0:
		sprite.frame = 3 # Up

func shoot_cannon():
	var cannon_ball_plr = CANNON_BALL_PLR.instantiate()
	cannon_ball_plr.global_position = self.global_position
	if cannon_ball_plr.has_method("set_direction"):
		cannon_ball_plr.set_direction(last_direction)
	get_parent().add_child(cannon_ball_plr) 

func update_health():
	health -= 1
	match health:
		0:
			get_tree().reload_current_scene()
		1:
			sprite1.frame = 0
			sprite2.frame = 1
			sprite3.frame = 1
		2:
			sprite1.frame = 0
			sprite2.frame = 0
			sprite3.frame = 1
		3:
			sprite1.frame = 0
			sprite2.frame = 0
			sprite3.frame = 0

func _on_level_loader_body_entered(body: Node2D) -> void:
	if body == self:
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/world_two.tscn")
