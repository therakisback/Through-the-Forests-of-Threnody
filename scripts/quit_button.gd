extends Button

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		_on_pressed()

func _on_pressed():
	get_tree().quit()
