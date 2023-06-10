extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Global.first_time_on_the_main_menu:
		Global.first_time_on_the_main_menu = false
		$togle_music.pressed = true
	else:
		$master.value = AudioServer.get_bus_volume_db(0)
		$songs.value = AudioServer.get_bus_volume_db(1)
	Global.current_main = "//scenes/menu.tscn"
	
func _on_story_mode_pressed():
	Global.points_needed_to_win = 15
	Global.switch_map("//scenes/start.tscn")

func _on_endless_mode_pressed():
	Global.points_needed_to_win = 1000
	Global.switch_map("//scenes/main.tscn")

func _on_tutorial_pressed():
	Global.switch_map("//scenes/sinematic/sinematicMain.tscn")

func _on_togle_music_toggled(button_pressed):
	if button_pressed:
		$music.play()
	else:
		$music.stop()

func _on_master_drag_ended(value_changed):
	if value_changed:
		change_volume(0,$master.value)
		
func _on_songs_drag_ended(value_changed):
	if value_changed:
		change_volume(1,$songs.value)

func change_volume(bus_index , value):
	print(AudioServer.get_bus_volume_db(bus_index))
	#var original = AudioServer.get_bus_volume_db(bus_index)
	AudioServer.set_bus_volume_db(bus_index, value)

