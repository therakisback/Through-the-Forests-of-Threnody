extends RigidBody3D

@export var lifetime: float = 10
@export var notice_modifier: float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.notice_modifier += notice_modifier


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if lifetime <= 0:
		Globals.notice_modifier -= notice_modifier
		free() # Kills the grenade
	else:
		Globals.player_pos = global_position
		lifetime -= delta
