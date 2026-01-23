extends StaticBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var cannon_marker: Marker2D = $CannonMarker
@export var fire_rate: float = 2.0
const CANNON_BALL = preload("uid://dq8pw52nyvl5h")
var enemySpeed: float = 50.0
var direction: int = 1
var shoot_timer: float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += enemySpeed * direction * delta
	
	if position.x >= 418:
		position.x = 418 
		direction = -1
		sprite.frame = 1
	elif position.x <= 351:
		position.x = 351 
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
