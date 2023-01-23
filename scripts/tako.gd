extends RigidBody2D
var power = 0
var shoot_pos
var can_shoot = false
var entered_once = false 

var direction = Vector2(0,0)
var xdir = 0
var ydir = 0
var touched_floor = 1
onready var animation_player = $Sprite/ap
onready var cursor = $cursor

#func _physics_process(delta):
	#angular_velocity = 0
	#rotation = 0
func _input(_event):
	if Input.is_action_pressed("space"):
		animation_player.play("prepare shot 2")
		if Input.is_action_pressed("d"):
			xdir += 10 
		if Input.is_action_pressed("w"):
			ydir += -10
		if Input.is_action_pressed("a"):
			xdir += -10
		if Input.is_action_pressed("s"):
			ydir += 10
	elif Input.is_action_just_released("space"):
		if xdir >= 200:#ugly, forgot the swich function 
			xdir = 200
		elif xdir<= (-200):
			xdir = -200
		if ydir >= 200:
			ydir = 200
		elif ydir <= -200:
			ydir = -200
		animation_player.play("shot")
		#print(xdir," " ,ydir)
		apply_central_impulse(Vector2((xdir * touched_floor),(ydir * touched_floor)))
		Global.emit_signal("oxygen_spended",(1))
		xdir = 0 
		ydir = 0
		touched_floor = 1
		
	if !can_shoot:
		return
	if Input.is_action_pressed("rightMouse"):
		power += 0.02
		if !entered_once:
			animation_player.play("prepare shot 2")
		entered_once = true
		cursor.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		shoot_pos = get_global_mouse_position() - global_position
		shoot_pos = shoot_pos.normalized() * clamp(shoot_pos.length(), 0, 200)
		var pointer_scale = shoot_pos.length() / 200 #200 = max_aim_distance
		cursor.scale = Vector2(0.15, 0.15) * log((1+pointer_scale)*3.0) #vector = max_cursor_scale 0.25, 0.25
		cursor.global_position = shoot_pos + global_position
	elif Input.is_action_just_released("rightMouse"):
		entered_once = false
		cursor.visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		animation_player.play("shot")
		mode = RigidBody2D.MODE_RIGID
		var speed = -shoot_pos
		apply_central_impulse(speed * (1 + power)) # 8 = speed modifier
		Global.emit_signal("oxygen_spended",(power + 2))
		power = 0

func _on_monitor_input_event(_viewport, _event, _shape_idx):
	can_shoot = true

func _on_Area2D_body_entered(body):
	if body is StaticBody2D and !entered_once:
		linear_velocity = Vector2(0,0)
		touched_floor = 2.5
		animation_player.play("idle")
#	if body is RigidBody2D:
#		if body.get_collision_mask_bit(3):
