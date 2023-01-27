extends RigidBody2D
var power = 0
var shoot_pos
var can_shoot = false
var direc = 0

onready var animation_player = $Sprite/ap
onready var cursor = $cursor
onready var fade_of_timer = $fade_of

func _physics_process(_delta):
	set_rotation(direc)

func _input(_event):
	if !can_shoot:
		return
	if Input.is_action_pressed("leftMouse"):
		power += 0.05
		animation_state("prepare shot 2")
		cursor.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		shoot_pos = get_global_mouse_position() - global_position
		shoot_pos = shoot_pos.normalized() * clamp(shoot_pos.length(), 0, 200)
		var pointer_scale = shoot_pos.length() / 200 #200 = max_aim_distance
		cursor.scale = Vector2(0.15, 0.15) * log((1+pointer_scale)*3.0) #vector = max_cursor_scale 0.25, 0.25
		cursor.global_position = shoot_pos + global_position
		direc = ((shoot_pos).angle() + PI)
		if power >= 5:
			power = 5
			linear_velocity = Vector2(0,0)
	elif Input.is_action_just_released("leftMouse"):
		animation_state("shot")
		fade_of_timer.start()
		cursor.visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		mode = RigidBody2D.MODE_RIGID
		var speed = -shoot_pos
		apply_central_impulse(speed * (1 + power)) # 8 = speed modifier
		Global.emit_signal("oxygen_spend",(power + 1))
		power = 0

func _on_monitor_input_event(_viewport, _event, _shape_idx):
	can_shoot = true

func _on_Area2D_body_entered(body):
	if body is StaticBody2D:
		linear_velocity = Vector2(0,0)
		animation_state("idle")
#	if body is RigidBody2D:
#		if body.get_collision_mask_bit(3):

func animation_state(name):
	animation_player.play(name)

func _on_fade_of_timeout():
	animation_state("idle")

