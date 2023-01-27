extends Node2D
export(String) var next_scene# = "res://scenes/maps/map1.tscn"
export(String) var kill_scene
export(int) var blocage_x = 10
export(int) var blocage_y = 10
onready var blocage_position = $blocage_position
onready var next_scene_pos = $next_scene_position
var scene
#onready var block_last_level = get_parent().get_node("entities")
#var blocage = preload("res://scenes/entities/blocage.tscn")

func _ready():
	if next_scene != "":
		scene = load(next_scene).instance()

func _on_activation_area_body_entered(body):
	if body.to_string().begins_with ("tako:"):
		if next_scene != "":
			call_deferred("instance_new_scene")
		if kill_scene != "":
			call_deferred("delete_old_scene")
		if blocage_x != 0 and blocage_y != 0:
			call_deferred("intance_the_thing")
		call_deferred("die")
		
func intance_the_thing():#https://docs.godotengine.org/es/stable/classes/class_object.html#class-object-method-call-deferred
	#var blocage_intance = blocage.instance()
	var blocage_intance = load("res://scenes/entities/blocage.tscn").instance()
	get_parent().add_child(blocage_intance)
	blocage_intance.visible = true
	blocage_intance.global_position = blocage_position.global_position#to_local(blocage_position.position)
	blocage_intance.scale = Vector2(blocage_x,blocage_y)
	call_deferred("die")

func instance_new_scene():
	scene.position = next_scene_pos.global_position + scene.get_position()
	get_parent().get_parent().get_parent().add_child(scene)

func delete_old_scene():
	get_parent().get_parent().get_parent().get_node(kill_scene).queue_free()

func die():
	queue_free()
