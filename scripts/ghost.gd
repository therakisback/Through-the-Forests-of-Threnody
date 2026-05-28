extends CharacterBody3D

var target_pos: Vector3

@export var prop: bool = false
@export_range(0, 2, 1) var prop_eyes: int = 0
@export var enemy_speed: float = .5
@export var notice_range: float = 35
@export var red_range: float = 15
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
	
	await get_tree().create_timer(randf_range(0, 5.0)).timeout
	$AudioStreamPlayer3D.play()

func _physics_process(_delta: float) -> void:
	# Check to see if "ai" should start
	if prop or not Globals.game_ready:
		return
	
	target_pos = Globals.player_pos
	# See if they are close enough for the shades to notice
	var distance := global_position.distance_to(target_pos)
	
	if distance < red_range * Globals.notice_modifier:
		_red()
	elif distance < notice_range * Globals.notice_modifier:
		_green()
	else:
		_gray()

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
	if eyes != 1:
		var green_eye := load("res://assets/green_eyes.tres")
		$"Right Eye".material_override = green_eye
		$"Left Eye".material_override = green_eye
		eyes = 1
	_chase()
	
	
# Run. Spill blood and their eyes turn red, granting them the ability to interact with people. fully.
func _red():
	if eyes != 2:
		var red_eye := load("res://assets/red_eyes.tres")
		$"Right Eye".material_override = red_eye
		$"Left Eye".material_override = red_eye
		eyes = 2
	_chase()
	
func _chase():
	# Initially I used "look_at()" but it was a very sudden turn,
	var new_transform = transform.looking_at(target_pos, Vector3.UP)
	transform  = transform.interpolate_with(new_transform, 0.1)
	# Calculate direction to move based on player pos and enemy pos
	var direction = -(global_position - target_pos).normalized()
	velocity = direction * enemy_speed
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity()
	
	move_and_slide()
