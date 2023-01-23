extends Node

signal move_camera(pos, zoom)

signal oxygen_spended(value)

signal oxygen_gained(value)

func switch_map(nombre):
	# warning-ignore:return_value_discarded
	get_tree().change_scene_to(load("res://" + nombre))
