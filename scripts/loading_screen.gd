extends ColorRect

# Number of items we need to wait to load, in this case, mostly proton scatter
@export var num_items: int
# This defines the minimum wait time, not minimum value for wait
@export var min_wait: float
@export var start_game: bool = true
@onready var loading_bar: ProgressBar = $MarginContainer/ProgressBar
@onready var music = $"../AudioStreamPlayer"

var wait := 0.0
# We need to record the last wait value so we don't add too much
var wait_value := 0.0
var value: float
var shares: float 

func _ready():
	shares = 100.0 / (num_items + 1) # 1 extra for wait time

func _process(delta: float) -> void:
	wait = min(min_wait, wait + delta) # Ensure wait is only ever min_wait
	var current_wait: float = (wait / min_wait * shares)
	value += (current_wait - wait_value)
	wait_value = current_wait
	loading_bar.value = value
	_check_finished()

func item_ready():
	print("Item finished")
	var item_value: float = shares
	value += item_value
	
func _check_finished():
	if loading_bar.value >= 99.0:
		hide()
		# ensures this only happens once
		if start_game:
			music.play()
			start_game = false
			Globals.game_ready = true
	
