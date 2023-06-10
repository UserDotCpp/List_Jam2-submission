extends Camera2D

# The starting range of possible offsets using random values
export var RANDOM_SHAKE_STRENGTH: float = 5.0
# Multiplier for lerping the shake strength to zero
export var SHAKE_DECAY_RATE: float = 3.0

onready var camera = $"."
onready var rand = RandomNumberGenerator.new()

var shake_strength: float = 0.0
var shake = false
onready var target_pos: Vector2 = position
export var target_zoom: Vector2 = zoom

export var follow_tako : bool

export(NodePath) var player_path
var player: Node2D

func _ready():
# warning-ignore:return_value_discarded
	Global.connect("screen_shake",self,"apply_shake")
# warning-ignore:return_value_discarded
	Global.connect("move_camera", self, "_on_move_camera")
# warning-ignore:return_value_discarded
	Global.connect("zoom_on_canera",self,"apply_zoom")
	player = get_node(player_path)
	rand.randomize()
	
func _physics_process(_delta):	
	if !follow_tako:#!Global.follow_tako:
		return
	position = lerp(position, player.position, 0.03)#position = lerp(position, target_pos, 0.03)
	zoom = lerp(zoom, target_zoom, 0.03)

func _process(delta):
	if !shake:
		return
	shake_strength = lerp(shake_strength, 0, SHAKE_DECAY_RATE * delta)
	camera.offset = get_random_offset()

func apply_zoom(value) -> void:
	target_zoom = Vector2(value,value)
	
func ending_shake() -> void:
	shake = true
	shake_strength = 10
	
func apply_shake(value) -> void:
	if value == 0:
		shake = false
	else:
		shake = true
	shake_strength = value

func _on_move_camera(new_pos: Vector2):#, new_zoom: Vector2):
	target_pos = new_pos
#	target_zoom = new_zoom

func get_random_offset() -> Vector2:
	return Vector2(
		rand.randf_range(-shake_strength, shake_strength),
		rand.randf_range(-shake_strength, shake_strength)
	)

#func phone_position_calculation():
	#print(self.get_camera_screen_center() -0.5*get_viewport_rect().size, " global")
	#pass
	#print(get_canvas_transform().xform_inv(event.position))
