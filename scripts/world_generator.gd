extends CanvasLayer

@onready var loading_screen = $"Loading Screen"
@export var ray_length: float = 64
@export var player_spawn_gap: float = 10
@export var enable_mobile_controls: bool = false

var template = preload("res://scenes/world_template.tscn")
var level = Globals.current_level

var world: Node3D
var terrain: StaticBody3D
var sky: Sky3D
var trees: ProtonScatter
var tree_spawn: ProtonScatterShape
var left_wall: StaticBody3D
var right_wall: StaticBody3D
var enemies: MeshInstance3D
var player: CharacterBody3D
var win: Area3D
@onready var loading: ColorRect = $"Loading Screen"
@onready var mobile_controls: Control = $"Mobile Controls"

signal finished_generating

func _ready() -> void:
	loading.start_game = true
	world = template.instantiate()
	
	terrain = world.get_child(0).get_child(0)
	sky = world.get_child(0).get_child(1)
	trees = world.get_child(0).get_child(2)
	tree_spawn =world.get_child(0).get_child(2).get_child(1)
	left_wall = world.get_child(0).get_child(3)
	right_wall = world.get_child(0).get_child(4)
	enemies = world.get_child(1)
	player = world.get_child(2)
	win = world.get_child(3) 
	_generate_level()
	
	add_child(world)
	print("Finished Generating")
	finished_generating.emit()
	
	# Here we will determine whether to enable mobile controls or not
	if DisplayServer.is_touchscreen_available() or enable_mobile_controls:
		mobile_controls.show()
	else:
		mobile_controls.hide()

func _generate_level():
	_create_terrain()
	_set_env()
	_characters()

func _create_terrain():
	terrain.width = level['width']
	terrain.length = level['length']
	terrain.height = level['height']
	terrain.noise.offset.x = randf_range(-1000, 1000)
	terrain.noise.offset.y = randf_range(-1000, 1000)
	terrain.update_mesh()
	
	# I remove a bit of the width at the sides to ensure there are not trees the player can get stuck on
	tree_spawn.shape.size = Vector3(level['width']-10, level['height']*2, level['length'])
	# The proton scatter documents are not great for scripting
	trees.modifier_stack.stack[0].amount = level['tree']
	trees.build_completed.connect(loading_screen.item_ready)
	
	left_wall.transform.origin.x = level['width']/2
	right_wall.transform.origin.x = -level['width']/2

func _set_env():
	sky.current_time = level['time']
	win.position = Vector3(0, 0, level['length']/2)
	

func _characters():
	enemies.mesh.size = Vector2(level['width'], level['length'] - 128)
	enemies.max_enemies = level['shade']
	Globals.notice_modifier = level['notice']
	connect("finished_generating", enemies.spawn_shadows)
	enemies.finished_spawning.connect(loading_screen.item_ready)
	
	player.speed = level['speed']
	print("Spawning at: ", Vector3(0, level['height']+2, -level['length']/2))
	player.transform.origin = Vector3(0, level['height']+2, -level['length']/2)
