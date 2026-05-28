extends Area3D

func _on_area_entered(area: Area3D) -> void:
	if area == $"../Player/Area3D":
		print("YOU WIN")
		Globals.game_ready = false
		var plus_score: int = Globals.current_level['difficulty'] * 10
		Globals.add_score(plus_score)
		Globals.default_text = ("Good job, but we got more people in need.\n\n Payment: %d" % plus_score)
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
