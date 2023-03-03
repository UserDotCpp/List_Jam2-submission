extends Node

var last_map_name = ""
var last_map_number_id = 0
var flag_passed = false
var map_counter = 0
var touched_the_wall = false
var touched_a_hazard  = false
var time_of_flag_trigger
 
# warning-ignore:unused_signal
signal move_camera(pos)#, _zoom)
# warning-ignore:unused_signal
signal oxygen_spend(value)
# warning-ignore:unused_signal
signal oxygen_gained(value)
# warning-ignore:unused_signal
signal spawn_worm()
# warning-ignore:unused_signal
signal level_finished()
# warning-ignore:unused_signal
signal screen_shake(value)

func switch_map(nombre):
	# warning-ignore:return_value_discarded
	#main.queue_free()
	get_parent().get_node("/root/main").queue_free()
	get_tree().change_scene_to(load("res://" + nombre))
