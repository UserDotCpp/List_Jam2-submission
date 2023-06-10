extends Node2D

func _ready():
# warning-ignore:return_value_discarded
	Global.connect("kill_sinematic_animations",self,"kill_animations")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Global.current_main = "//scenes/sinematic/sinematicMain.tscn"
	Global.last_map_name = ""
	Global.flag_passed = false
	Global.map_counter = 1

var first_time = true
# warning-ignore:unused_argument
func _input(event):
	if Input.is_action_pressed("r"):
		Global.current_main = "//scenes/sinematic/sinematicMain.tscn"
		Global.switch_map("//scenes/menu.tscn")
	if Input.is_action_pressed("q") and self.get_path() != "/root/mainSin":
		finish_fits_tutorial()
	if !first_time:
		return
	if Input.is_action_pressed("leftMouse") and self.get_path() == "/root/main00":# and Global.map_counter == 2:
		first_time = false
		$camera.follow_tako = false
		$aps/scripted_start.play("1")

	#else:
		#$tako.can_play = true
		#$camera.follow_tako = true

#https://github.com/godotengine/godot/issues/8985
func tree_exited():
	for instanced_maps in get_node("level").get_children ():
		instanced_maps.queue_free()
#		call_deferred("die",instanced_maps)

func finish_fits_tutorial():
	Global.switch_map("//scenes/sinematic/sinematicTutorial.tscn")
	self.queue_free()

func kill_animations():
	$tako.manual_stop = true
	for instanced_maps in get_node("aps").get_children ():
		instanced_maps.queue_free()
	for instanced_maps in get_node("level").get_node("m0").get_children ():
		instanced_maps.queue_free()
#func die(instanced_maps):
#	instanced_maps.queue_free()

