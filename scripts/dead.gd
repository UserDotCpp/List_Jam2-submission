extends CanvasLayer

func _input(_event):
	if Input.is_action_pressed("rightMouse"):
		Global.current_main = "//scenes/dead.tscn"
		Global.switch_map("//scenes/menu.tscn")
