# Started with pre-generated default FPS character template
extends CharacterBody3D

# Core variables
@export var strafe_speed: float = 5.0
@export var speed: float = 12
@export var load_wait_time: float = 0.5
@export var death_wait_time: float = 0.5

# These are variables for abilites
@export var magnesium_lifetime: float = 7.5
var grenade_current_life: float = 0
@export var attack_range: float = 1.5
@export var aluminum_piece_modifier: float = 0.9
@export var primary_delay: float = 1
var attack_delay: float = 0
var grenade_delay: float = 0

# Debug variables
@export var godmode: bool = false

# Due to listening to only areas and ignoring the player's
# This will only list shades
@onready var attack: ShapeCast3D = $Area3D/ShapeCast3D
@onready var sound_player = $AudioStreamPlayer
var grenade = preload("res://scenes/magnesium_grenade.tscn")

func _ready():
	Globals.notice_modifier *= pow(aluminum_piece_modifier, Globals.aluminum)

func _process(delta: float) -> void:
	attack_delay = max(0, attack_delay - delta)
	grenade_delay = max(0, grenade_delay - delta)
	grenade_current_life = max(0, grenade_current_life - delta)
	if grenade_current_life <= 0:
		Globals.player_pos = global_position
	
	if Input.is_action_just_pressed("attack") and attack_delay <= 0 :
		# If the player is using silver, attack
		if Globals.silver > 0:
			sound_player.play()
			# We remove silver / pewter because each purchase should be on click, not one kill
			if attack.is_colliding():
				if Globals.pewter > 0:
					Globals.pewter -= 1
				else:
					Globals.silver -= 1 
			for index in attack.get_collision_count():
				var hurtbox = attack.get_collider(index)
				# Doesn't exactly "kill" them, but effectively does
				hurtbox.get_parent().free()
				attack_delay = primary_delay
		
	if Input.is_action_just_pressed("special") and grenade_delay <= 0:
		if Globals.magnesium > 0:
			Globals.magnesium -= 1
			var new_nade: RigidBody3D = grenade.instantiate()
			new_nade.position = global_position
			new_nade.position.z += 1.2
			new_nade.lifetime = magnesium_lifetime
			get_parent().add_child(new_nade)
			
			var throwx: float
			# We will throw away from the wall
			if global_position.x >= 0:
				throwx = -500
			else:
				throwx = 500
			var throwy: float = 500
			var throwz: float = 2000
			var throw_direction: = Vector3(throwx, throwy, throwz)
			new_nade.apply_force(throw_direction, Vector3.ZERO)
			
			grenade_current_life = magnesium_lifetime
			grenade_delay = magnesium_lifetime * primary_delay
			

func _physics_process(_delta: float) -> void:
	# Dont move if the game isn't ready.
	if not Globals.game_ready:
		# Except gravity, it removes any chance of clipping through the floor on spawn if we just fall into place
		if not is_on_floor():
			velocity += get_gravity()
			move_and_slide()
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity()

	# The inputs have to be flipped here to be right in the game
	var input_dir = Input.get_axis("right", "left")
	
	velocity.x = input_dir * strafe_speed
	velocity.z = 1 * speed
	
	move_and_slide()
	
	#TODO If player collides with a tree, nudge to the side by some amount

func _die(_body: Area3D) -> void:
	if godmode:
		return
	Globals.reset_score()
	Globals.game_ready = false
	await get_tree().create_timer(death_wait_time).timeout
	get_tree().change_scene_to_file("res://scenes/death_screen.tscn")
