extends Node

var last_map_name = ""
var last_map_number_id = 0
var flag_passed = false
var map_counter = 0
var touched_the_wall = false
var touched_a_hazard  = false
var time_of_flag_trigger
var current_main = "/root/main"
var points_needed_to_win  #if it is 1000 or more, you are playing in endlees mode
var follow_tako = true
var first_time_on_the_main_menu = true

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
# warning-ignore:unused_signal
signal zoom_on_canera(value)
# warning-ignore:unused_signal
signal kill_sinematic_animations()

func switch_map(nombre):
	# warning-ignore:return_value_discarded
	#main.queue_free()
	#get_parent().get_node(current_main).queue_free()
	get_tree().change_scene_to(load("res://" + nombre))
