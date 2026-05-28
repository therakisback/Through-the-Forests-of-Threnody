extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pause_resume()

func exit():
	Globals.reset_score()
	get_tree().change_scene_to_file("res://scenes/death_screen.tscn")

func pause_resume():
	if Globals.game_ready:
		# This is being repurposed here, as get_tree().pause does not work right
		Globals.game_ready = false
		print(Globals.game_ready)
		show()
	else:
		Globals.game_ready = true
		hide()
