extends StaticBody2D

var cannonSpeed = 0.1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position.y -= cannonSpeed

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		SignalBus.player_hit.emit()
		queue_free()
