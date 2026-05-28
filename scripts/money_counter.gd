extends RichTextLabel

func _ready():
	_update_money()

# Its annoying to have a script with one method but no other script can hold this.
func _update_money():
	text = ("$%d" % Globals.money)
