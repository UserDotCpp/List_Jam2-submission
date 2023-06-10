extends RigidBody2D

onready var pull_zone = $monitor
var traped = false

func _on_monitor_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	#if body is RigidBody2D && body.get_collision_layer_bit(2):
	if body.to_string().begins_with ("tako:") and body.get_collision_mask() == 2:
		Global.touched_a_hazard = true
		Global.emit_signal("oxygen_spend",2)
		var impulse = to_local(body.global_position).normalized()
		body.linear_velocity += (to_global(impulse) - pull_zone.global_position) * -1000

