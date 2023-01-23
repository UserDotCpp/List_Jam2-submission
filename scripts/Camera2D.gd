extends Camera2D

onready var target_pos: Vector2 = position
onready var target_zoom: Vector2 = zoom

export var follow_tako = true

export(NodePath) var player_path
var player: Node2D

func _ready():
	Global.connect("move_camera", self, "_on_move_camera")
	player = get_node(player_path)
	

func _physics_process(_delta):
	if !follow_tako:
		return
	position = lerp(position,player.position,0.03)#position = lerp(position, target_pos, 0.03)
	#zoom = lerp(zoom, target_zoom, 0.03)

func _on_move_camera(new_pos: Vector2, new_zoom: Vector2):
	target_pos = new_pos
	target_zoom = new_zoom
