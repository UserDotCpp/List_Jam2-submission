extends CanvasLayer


func _input(_event):
	if Input.is_action_pressed("r"):
		force_to_end()
	if Input.is_action_pressed("q") and self.get_path() != "/root/win":
		force_to_start()

func force_to_start():
	Global.points_needed_to_win = 15
	Global.current_main = "//scenes/start.tscn"
	Global.switch_map("//scenes/sinematic/sinematicStart.tscn")

func force_to_end():
	Global.current_main = "//scenes/win.tscn"
	Global.switch_map("//scenes/menu.tscn")
