extends RichTextLabel

func _update():
	text = ("Silver: %d         Pewter: %d         Magnesium: %d         Aluminum: %d" % [Globals.silver, Globals.pewter, Globals.magnesium, Globals.aluminum])
