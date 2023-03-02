extends CanvasLayer
onready var fps = $fps
onready var time_passed = $time
onready var time_changes = $time_changes
onready var combo_number = $combo_number
onready var combo_tune = $combo
export var total_time = 60#30 is good
var combo
var combo_text =""
func _ready():
	combo_tune.pitch_scale = 1
	combo = 0
	Global.time_of_flag_trigger = total_time
# warning-ignore:return_value_discarded
	Global.connect("oxygen_spend",self,"lost_seconds")
# warning-ignore:return_value_discarded
	Global.connect("oxygen_gained",self,"gained_seconds")
# warning-ignore:return_value_discarded
	Global.connect("level_finished", self,"combo_engine")

func combo_engine():
	#combo_number.module = Color(0.0, 1.0, 0.0, 1.0)
	
	if total_time >= Global.time_of_flag_trigger - 25:
		$combo_notification.text = " "
		if !Global.touched_a_hazard:
			combo += 1
			combo_text = combo_text + " hazards avoided "
			$fade_out.start()
		if !Global.touched_the_wall:
			combo += 1
			combo_text = combo_text + " no touched wall "
			$fade_out.start()
		combo += 1
		$combo_text.text = "combo"
		$combo_notification.text = combo_text
		combo_number.text = str(combo)
		flag_up()
	else:
		combo = 0
		combo_number.text = " "
		combo_tune.pitch_scale = 1
		$combo_notification.text = "2 slow"
		$combo_drop.play()
		$combo_text.text = " "
		$fade_out.start()
	Global.time_of_flag_trigger = total_time


func flag_up():
	if combo_tune.pitch_scale <= 6:
		combo_tune.pitch_scale += 0.03
	combo_tune.play()
	$last_time.modulate = Color(255, 255, 255, 1.0)
	$last_time.text =str("%03d" % (total_time - Global.time_of_flag_trigger))

func lost_seconds(value):
	time_changes.modulate = Color(1.0, 0.0, 0.0, 1.0)
	$fade_out.start()#$fade_out.start(0.015)
	time_changes.text = "-"+ str(value)
	total_time -= value
	if total_time < 60:
		$time_leyend.text = ""

func gained_seconds(value):
	$bubble.play()
	time_changes.modulate = Color(0.0, 1.0, 0.0, 1.0)
	$fade_out.start()#$fade_out.start(0.015)
	time_changes.text = "+"+ str(value)
	total_time += value
	if total_time > 60:
		$time_leyend.text = str("+",int(total_time / 60),"extra tanks")

func _process(delta):
	fps.text = str(Engine.get_frames_per_second())
	total_time -= delta
	var mils = fmod(total_time,1)*1000
	var secs = fmod(total_time,60)
	time_passed.text = "%02d : %03d" % [secs,mils]
#	if $fade_out.is_stopped():#0.055
#		time_changes.text = " " 
#		$bubble.stop()
	if $worm_attack.is_stopped():
		$worm_attack.start(0.0165)
		Global.emit_signal("spawn_worm")
	if total_time <= 0:
		$me_mori.play()
		Global.switch_map("//scenes/main.tscn")

func _on_fade_out_timeout():
	combo_text =""
	time_changes.text = " "
	$combo_notification.text = " "
#	$bubble.stop()
	$fade_out.stop()
