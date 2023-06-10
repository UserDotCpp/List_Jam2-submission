extends Node2D

func _ready():
# warning-ignore:return_value_discarded
	if Global.points_needed_to_win == 15:
		$level/m0/entities/pipe.show()
		$level/m0/entities/pipe/ap.play("close_door")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Global.current_main = "//scenes/main.tscn"
	Global.last_map_name = ""
	Global.flag_passed = false
	Global.map_counter = 1

#https://github.com/godotengine/godot/issues/8985
func tree_exited():
	for instanced_maps in get_node("level").get_children ():
		instanced_maps.queue_free()
#		call_deferred("die",instanced_maps)
		
#func die(instanced_maps):
#	instanced_maps.queue_free()
