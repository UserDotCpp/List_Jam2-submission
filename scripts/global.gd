extends Node

# warning-ignore:unused_signal
signal move_camera(pos, _zoom)
# warning-ignore:unused_signal
signal oxygen_spend(value)
# warning-ignore:unused_signal
signal oxygen_gained(value)

func switch_map(nombre):
	# warning-ignore:return_value_discarded
	#main.queue_free()
	get_parent().get_node("/root/main").queue_free()
	get_tree().change_scene_to(load("res://" + nombre))
