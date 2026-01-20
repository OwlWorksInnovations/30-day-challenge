extends StaticBody2D

var cannonSpeed = 0.1
var player_node = null

func _ready() -> void:
	player_node = get_tree().get_first_node_in_group("player")

func _process(_delta: float) -> void:
	if player_node:
		var sprite = player_node.get_node("AnimatedSprite2D")
		
		match sprite.frame:
			0:
				position.x -= cannonSpeed
				position.y += cannonSpeed
			1:
				position.y += cannonSpeed
			2:
				position.x -= cannonSpeed
			3:
				position.x += cannonSpeed
			4:
				position.x += cannonSpeed
				position.y += cannonSpeed
			5:
				position.y -= cannonSpeed
			6:
				position.x += cannonSpeed
				position.y -= cannonSpeed
			7:
				position.x -= cannonSpeed
