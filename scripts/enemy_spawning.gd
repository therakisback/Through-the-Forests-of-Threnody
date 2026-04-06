extends MeshInstance3D

# We are using a MeshInstance so that size is easily adjustable and visible.

var enemies : int = 0

# Only usable when its set to a @tool script - which I don't recommend unles debugging
@export var run_spawn_func: bool = false:
	set(val):
		cast_ray()

@export var max_enemies: int = 1
@export var ray_length: float = 16
@export var spawn_transform: Vector3
var size : Vector2 = mesh.size


func _ready() -> void:
	print("Spawning shadows")
	while get_child_count() < max_enemies:
		var ray_pos = cast_ray()
		if (ray_pos.length() > 0):
			spawn_enemy(ray_pos)
		else:
			print("Enemy Spawn RayCast detected no collider!")
		
func cast_ray() -> Vector3:
	# Establish variables for a raycast to find the terrain
	var space_state := get_world_3d().direct_space_state
	var ray_x := (randf() - 0.5) * size.x
	var ray_y := (randf() - 0.5) * size.y
	var start := Vector3(ray_x, ray_length, ray_y)
	var end := Vector3(ray_x, -ray_length, ray_y)
	# This selects only the "terrain" layer & mask for collision
	var collision_bitmask := 0b00000000_00000000_00000000_00000100
	
	var query := PhysicsRayQueryParameters3D.create(start, end, collision_bitmask)
	var result: Dictionary = space_state.intersect_ray(query)
	if (result.size() > 0):
		return result['position']
	return Vector3.ZERO

func spawn_enemy(pos: Vector3) -> void:
	var enemy_path := preload("res://scenes/ghost.tscn")
	
	var enemy : CharacterBody3D = enemy_path.instantiate()
	enemy.position = pos + spawn_transform
	add_child(enemy)
	
	enemies += 1
