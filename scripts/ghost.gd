extends CharacterBody3D

var target_pos: Vector3

@export var prop: bool = false
@export_range(0, 2, 1) var prop_eyes: int = 0
@export var enemy_speed: float = .5
@export var notice_range: float = 35
var eyes :int = 0

func _ready():
	if prop:
		if prop_eyes == 0:
			_gray()
		elif prop_eyes == 1:
			_green()
		else:
			_red()
		return
	
	var player = get_tree().current_scene.get_node("Player")
	
	if player:
		player.position_changed.connect(_on_player_moved)
	else:
		print("Shadow could not find player!")

func _physics_process(_delta: float) -> void:
	if prop:
		return
	# See if they are close enough for the shades to notice
	if global_position.distance_to(target_pos) < notice_range:
		_green()
	else:
		_gray()
		

func _on_player_moved(new_pos: Vector3):
	target_pos = new_pos

# The colors describe their behaviors and their appearance
# Gray is passive, in the book they meander, for simplicity they stay still for now
func _gray():
	if eyes != 0:
		var gray_eye := load("res://assets/green_eyes.tres")
		$"Right Eye".material_override = gray_eye
		$"Left Eye".material_override = gray_eye
		eyes = 0
	
# Green is agitated, bother the shades and their eyes turn green. Certainly not safe, but not terrible
func _green():
	# If the shades notice, have them look at the player and change their eye color
	# Initially I used "look_at()" but it was a very sudden turn,
	var new_transform = transform.looking_at(target_pos, Vector3.UP)
	transform  = transform.interpolate_with(new_transform, 0.1)
	if eyes != 1:
		var green_eye := load("res://assets/green_eyes.tres")
		$"Right Eye".material_override = green_eye
		$"Left Eye".material_override = green_eye
		eyes = 1
	# Calculate direction to move based on player pos and enemy pos
	var direction = -(global_position - target_pos).normalized()
	velocity = direction * enemy_speed
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity()
	
	move_and_slide()
	
# Run. Spill blood and their eyes turn red, granting them the ability to interact with people. fully.
func _red():
	pass
