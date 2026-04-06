# Started with pre-generated default FPS character template
extends CharacterBody3D

@export var strafe_speed: float
@export var speed: float
@export var load_wait_time: int = 30

signal position_changed(global_position)

func _process(_delta: float) -> void:
	position_changed.emit(global_position)

func _physics_process(delta: float) -> void:
	# Wait a bit so enemies can spawn and level can load
	if (load_wait_time > 0):
		load_wait_time = load_wait_time - 1
		return
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity()

	var input_dir = 0
	if Input.is_action_pressed("left"):
		input_dir += 1
	if Input.is_action_pressed("right"):
		input_dir += -1

	if input_dir != 0:
		velocity.x = input_dir * strafe_speed
	else:
		velocity.x = move_toward(velocity.x, 0, strafe_speed)
	velocity.z = 1 * speed

	move_and_slide()
