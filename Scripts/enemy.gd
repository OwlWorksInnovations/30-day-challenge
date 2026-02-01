extends StaticBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var cannon_marker: Marker2D = $CannonMarker
@export var fire_rate: float = 2.0
const CANNON_BALL = preload("uid://dq8pw52nyvl5h")
const HEALTH_ENEMY = preload("uid://uxu717tkkgge")
var enemySpeed: float = 50.0
var direction: int = 1
var shoot_timer: float = 0.0

var health_instance: Control
var sprite1: AnimatedSprite2D
var sprite2: AnimatedSprite2D
var sprite3: AnimatedSprite2D
var health: int = 3

func _ready() -> void:
	SignalBus.enemy_hit.connect(update_health)
	
	health_instance = HEALTH_ENEMY.instantiate()
	get_tree().root.add_child.call_deferred(health_instance)
	
	sprite1 = health_instance.get_node("1")
	sprite2 = health_instance.get_node("2")
	sprite3 = health_instance.get_node("3")
	
	sprite1.frame = 0
	sprite2.frame = 0
	sprite3.frame = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += enemySpeed * direction * delta
	health_instance.position.x = self.position.x - 5
	health_instance.position.y = self.position.y + -17
	
	if position.x >= 224.0:
		position.x = 224.0
		direction = -1
		sprite.frame = 1
	elif position.x <= 89.0:
		position.x = 89.0
		direction = 1
		sprite.frame = 0
	
	shoot_timer += delta
	if shoot_timer >= fire_rate:
		shoot_cannon()
		shoot_timer = 0.0

func shoot_cannon():
	var cannon_ball = CANNON_BALL.instantiate()
	cannon_ball.global_position = cannon_marker.global_position
	get_parent().add_child(cannon_ball)
	
func update_health():
	health -= 1
	match health:
		0:
			queue_free()
			health_instance.queue_free()
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
