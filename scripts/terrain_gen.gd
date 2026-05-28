# Code adapted from https://www.youtube.com/watch?v=OUnJEaatl2Q
@tool
extends StaticBody3D

@onready var terrain_mesh = $TerrainMesh
@onready var terrain_col = $TerrainCollision

@export var generate_mesh: bool = false:
	set(new_bool):
		update_mesh()

@export var width: float = 64.0
@export var length: float = 256.0

@export var noise: FastNoiseLite

@export var height:float = 16.0

func get_height(x: float, y: float) -> float:
	if noise:
		return noise.get_noise_2d(x, y) * height
	else:
		return 0

func _ready() -> void:
	update_mesh()

func update_mesh() -> void:
	if not is_inside_tree():
		return
	print("Generating Mesh")
	# Create initial plane
	var plane := PlaneMesh.new()
	@warning_ignore("narrowing_conversion")
	plane.subdivide_depth = length / 16
	@warning_ignore("narrowing_conversion")
	plane.subdivide_width = width / 16
	plane.size = Vector2(width, length)
	
	# Create surface tool and get plane vertices
	var surface = SurfaceTool.new()
	surface.create_from(plane, 0)
	var data = surface.commit_to_arrays()
	var vertices = data[ArrayMesh.ARRAY_VERTEX]
	
	# Assign vertex height based on noisemap
	for i:int in vertices.size():
		var vertex = vertices[i]
		vertices[i].y = get_height(vertex.x, vertex.z)
	data[ArrayMesh.ARRAY_VERTEX] = vertices
	
	# Add surface to arraymesh
	var array_mesh := ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, data)
	
	# Create surface from arraymesh and generate normals
	surface.create_from(array_mesh, 0)
	surface.generate_normals()
	terrain_mesh.mesh = surface.commit()
	# Generate and add collider shape
	terrain_col.shape = array_mesh.create_trimesh_shape()
