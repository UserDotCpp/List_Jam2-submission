extends CanvasLayer
onready var fps = $fps
onready var time_passed = $time
onready var time_changes = $time_changes
export var total_time = 15

func _ready():
	Global.connect("oxygen_spended",self,"lost_seconds")
	Global.connect("oxygen_gained",self,"gained_seconds")

func lost_seconds(value):
	time_changes.modulate = Color(1.0, 0.0, 0.0, 1.0)
	$fade_out.start(0.015)
	time_changes.text = "-"+ str(value)
	total_time -= value

func gained_seconds(value):
	time_changes.modulate = Color(0.0, 1.0, 0.0, 1.0)
	$fade_out.start(0.015)
	time_changes.text = "+"+ str(value)
	total_time += value

func _process(delta):
	fps.text = str(Engine.get_frames_per_second())
	total_time -= delta
	var mils = fmod(total_time,1)*1000
	var secs = fmod(total_time,60)
	time_passed.text = "%02d : %03d" % [secs,mils]
	if $fade_out.is_stopped():
		time_changes.text = " "
	if total_time <= 0:
		Global.switch_map("scenes/maps/map1.tscn")
