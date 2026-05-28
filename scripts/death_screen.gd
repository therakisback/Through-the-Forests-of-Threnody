extends CanvasLayer

func _ready():
	Globals.game_ready = false

func _unhandled_key_input(event):
	if event.is_pressed():
		_menu()

func _menu():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
