extends RigidBody2D

onready var pull_zone = $monitor
onready var line = $the_line

var traped = false

func _on_monitor_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is RigidBody2D && body.get_collision_layer_bit(2):
		#if body.linear_velocity < Vector2 (180,0) or body.linear_velocity < Vector2 (0,180):
		var impulse = to_local(body.global_position).normalized()
		body.linear_velocity += (to_global(impulse) - pull_zone.global_position) * -1000

