extends Area2D

func _on_bubble_body_entered(body):
	if body.to_string().begins_with ("tako:"):
		Global.emit_signal("oxygen_gained",20)
		call_deferred("queue_free")
