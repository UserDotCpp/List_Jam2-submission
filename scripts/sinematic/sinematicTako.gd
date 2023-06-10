extends RigidBody2D
var power = 1
var shoot_pos
var can_shoot = false
var direc = 0
var aiming = false
var last = 0
var first_time_chargin = true
var shot = false
onready var animation_player = $ap
onready var cursor = $cursor
onready var fade_of_timer = $fade_of

onready var the_progress_bar = $ui/ProgressBar
onready var mainui = $ui
onready var ui = $ui/ProgressBar
export var can_play = true
export var manual_stop = false

var power_konstant
var primera_tuto_charge = true
var primera_tuto_stop = true

func _ready():
	if self.get_parent().get_path() == "/root/main00":
		power_konstant = 0.25
	else:
		power_konstant = 2.5
	if self.get_parent().get_path() == "/root/mainSin":
		Global.follow_tako = false
		cursor.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mode = RigidBody2D.MODE_RIGID

func _physics_process(_delta):
	set_rotation(direc)
	mainui.set_rotation(-direc)
#https://www.youtube.com/watch?v=vVDVJMomxBU
#https://godotengine.org/qa/28543/godot-3-0-2-get-global-position-from-touchscreen
func _input(event):
	if !can_shoot:
		return
	if Input.is_action_pressed("leftMouse"):
		shot = false
		ui.show()
		if first_time_chargin: 
			animation_state("charging shot")
		first_time_chargin = false
		cursor.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		shoot_pos = get_canvas_transform().xform_inv(event.position) - global_position #shoot_pos = get_global_mouse_position() - global_position#shoot_pos =to_global(event.position) - global_position
		shoot_pos = shoot_pos.normalized() * clamp(shoot_pos.length(), 0, 200)
		var pointer_scale = shoot_pos.length() / 200 #200 = max_aim_distance
		cursor.scale = Vector2(0.15, 0.15) * log((1+pointer_scale)*1.50) #vector = max_cursor_scale 0.25, 0.25
		cursor.global_position = shoot_pos + global_position
		direc = ((shoot_pos).angle() + PI)
		if power >= 100:
			return
		if shoot_pos.angle() >= last+0.01 or shoot_pos.angle() <= last-0.01:
			power = power + power_konstant#power*0.25
			#power += 1#0.05
		elif primera_tuto_charge and self.get_parent().get_path() == "/root/main00":
			$next_dialog.start()
			primera_tuto_charge = false
		last = shoot_pos.angle()
		the_progress_bar.value = power
		#linear_velocity = Vector2(0,0)
		#the_progress_bar.value = power
	elif Input.is_action_just_released("leftMouse"):
		$release_gas.pitch_scale = 1 + power * 0.01#(randi() % 10 + 1)*0.1
		$release_gas.play()
	#elif Input.is_action_just_pressed("rightMouse"):
		#Global.emit_signal("get_touch_real_global_position")
		shot = true
		first_time_chargin = true
		if power >= 10:
			animation_state("shot")
			fade_of_timer.start()
		cursor.visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		mode = RigidBody2D.MODE_RIGID
		var speed = -shoot_pos
		apply_central_impulse((speed* 0.01) * (power * 5))#apply_central_impulse((speed* 0.05) * (1 + power)) # 8 = speed modifier
		Global.emit_signal("oxygen_spend",(1+power*0.03))#Global.emit_signal("oxygen_spend",(power + 1))
		power = 1
		ui.hide()
	if Input.is_action_just_pressed("rightMouse"):
		#Global.switch_map("//scenes/dead.tscn")
		$release_gas.pitch_scale = 1 +(randi() % 10 + 1)*0.1
		$release_gas.play()
		linear_velocity = linear_velocity* 0.05
		animation_state("shot")
		fade_of_timer.start()#power*0.01)
		
	#	cursor.visible = false
	#	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_monitor_input_event(_viewport, _event, _shape_idx):
	if !can_play:
		return
	can_shoot = true

func _on_Area2D_body_entered(body):
	if body is StaticBody2D:
		# warning-ignore:integer_division
		$hit.pitch_scale = 1 + (randi() % 20 + 1)/10
		$hit.play()
		Global.touched_the_wall = true
		linear_velocity = linear_velocity* 0.5#Vector2(0,0)
		if shot and !first_time_chargin:
			animation_state("idle")
#	if body is RigidBody2D:
#		if body.get_collision_mask_bit(3):

func animation_state(name):
	animation_player.play(name)

func dead_stop():
	linear_velocity = linear_velocity* 0.01

func _on_fade_of_timeout():
	if shot:
		animation_state("idle")

func _on_next_dialog_timeout():
	$next_dialog.stop()
	get_parent().get_node("aps/scripted_start").play("2")
