extends Node2D
var next_scene#export(String) var next_scene# = "res://scenes/maps/map1.tscn"
var kill_scene #export(String) var kill_scene
export(int) var blocage_x = 10
export(int) var blocage_y = 10
export(bool) var spawn_worm = true
onready var blocage_position = $blocage_position
onready var next_scene_pos = $next_scene_position
var up 
var down
var scene
var worm_exist = false
var rng = RandomNumberGenerator.new()
var worm1 = preload("res://scenes/entities/worm1.tscn")
var worm2 = preload("res://scenes/entities/worm2.tscn")
var worm3 = preload("res://scenes/entities/worm3.tscn")
#onready var block_last_level = get_parent().get_node("entities")
#var blocage = preload("res://scenes/entities/blocage.tscn")


func _ready():
# warning-ignore:return_value_discarded
	if spawn_worm:
		Global.connect("spawn_worm",self,"spawn_the_worm")
	#up = Vector3($up.get_point_position(0).x,$up.get_point_position(1).x,$up.get_point_position(1).y)
	#down = Vector3($down.get_point_position(0).x,$down.get_point_position(1).x,$down.get_point_position(1).y)
	rng.randomize()
	#var current_map_number = rng.randi_range(1,4)
	#if current_map_number == Global.last_map_number_id:
		#current_map_number += 1
		#if current_map_number == (4 + 1):
		#	current_map_number = rng.randi_range(1,3)#current_map_number = 1
	if Global.map_counter >= 3:
		return
	next_scene = str("res://scenes/sinematic/mapB0.tscn")#next_scene = str("res://scenes/maps/map",(randi() % 3 + 1),".tscn")#var n = randi() % (MAX - MIN) + MIN
	#Global.last_map_number_id = current_map_number
	scene = load(next_scene).instance()

func spawn_the_worm():
	var worm_instance
	var width
	match(randi() % 3 + 1):
		1:
			worm_instance = worm1.instance()
			width = 30
			Global.emit_signal("screen_shake",6)
		2:
			worm_instance = worm2.instance()
			width = 50
			Global.emit_signal("screen_shake",12)
		3:
			worm_instance = worm3.instance()
			width = 100
			Global.emit_signal("screen_shake",18)
	var worm_rotation_degrees
	var worm_spawn_position
	var worm_direction
	for old_instanced_worms in get_node("worm_place").get_children ():
			old_instanced_worms.queue_free()
	#		worm_instance.queue_free()
	rng.randomize()
	$direction_line.width = width
	if (randi() % 2 + 1) == 1:#up or down
		worm_spawn_position = Vector2(rng.randf_range(up.x, up.y),up.z)
		worm_direction = Vector2(rng.randf_range(down.x, down.y),down.z)
		var direction = worm_direction - worm_spawn_position
		var real_angle = (direction.angle() * 180) / PI

		$direction_line.set_point_position(0 , worm_spawn_position)
		$direction_line.set_point_position(1, worm_direction)
		var x = worm_direction - worm_spawn_position
		x = x.normalized() * x.length()
		worm_rotation_degrees = real_angle + 90 
	else:
		worm_spawn_position = Vector2(rng.randf_range(down.x, down.y),down.z)
		worm_direction = Vector2(rng.randf_range(up.x, up.y),up.z)
		var direction = worm_direction - worm_spawn_position
		var real_angle = (direction.angle() * 180) / PI
		$direction_line.set_point_position(0, worm_spawn_position)
		$direction_line.set_point_position(1, worm_direction)
		var x = worm_direction - worm_spawn_position
		x = x.normalized() * x.length()
		worm_rotation_degrees = real_angle + 90
	#$worm/body1.position = worm_spawn_position
	get_node("worm_place").add_child(worm_instance)
	worm_instance.z_index = 1
	worm_instance.position = worm_spawn_position
	worm_instance.rotation_degrees = worm_rotation_degrees
	#yield(get_tree().create_timer(1), "timeout")
	#worm_instance.rotation_degrees = get_angle_to(worm_direction)
	worm_instance.apply_central_impulse((worm_direction - worm_spawn_position) * 6)
	worm_exist = true

func _on_activation_area_body_entered(body):
	if body.to_string().begins_with ("tako:"):
		get_parent().get_node("door/door/ap").play("die")
		Global.emit_signal("screen_shake",22)
		if kill_scene != "" and Global.flag_passed:
			delete_old_scene()
		if next_scene != "":
			call_deferred("instance_new_scene")
		if blocage_x != 0 and blocage_y != 0:
			call_deferred("intance_the_blocage")
		call_deferred("die")
		Global.emit_signal("level_finished")
		Global.touched_the_wall = false
		Global.touched_a_hazard = false

func intance_the_blocage():#https://docs.godotengine.org/es/stable/classes/class_object.html#class-object-method-call-deferred
	#var blocage_intance = blocage.instance()
	var blocage_intance = load("res://scenes/entities/blocage.tscn").instance()
	get_parent().add_child(blocage_intance)
	blocage_intance.visible = true
	blocage_intance.global_position = blocage_position.global_position#to_local(blocage_position.position)
	blocage_intance.scale = Vector2(blocage_x,blocage_y)
	call_deferred("die")

#https://docs.godotengine.org/en/stable/classes/class_nodepath.html
func instance_new_scene():
	if Global.map_counter <= 3:
		Global.follow_tako = true
		if self.get_path() == "/root/mainSin/level/m0/entities/flag":
			Global.switch_map("//scenes/main.tscn")
		elif(Global.map_counter == 1):
			Global.current_main = "//scenes/sinematic/sinematicTutorial.tscn"
			Global.switch_map("//scenes/menu.tscn")
			#Global.switch_map("//scenes/sinematic/sinematicStart.tscn")
		scene.position = next_scene_pos.global_position + scene.get_position()
		scene.set_name(str("m",Global.map_counter))
		Global.map_counter += 1 
		get_parent().get_parent().get_parent().add_child(scene)
		Global.last_map_name = str(get_parent().get_parent())
		Global.flag_passed = true

func delete_old_scene():
	get_parent().get_parent().get_parent().get_node(str("m",Global.map_counter-1)).get_node("door_closing_sound").play()#Global.last_map_name).get_node("door_closing_sound").play()
	call_deferred("on_die")
	#$die.start()
func die():
	queue_free()

func on_die():
	get_parent().get_parent().get_parent().get_node(Global.last_map_name).call_deferred("queue_free")
	Global.flag_passed = false

