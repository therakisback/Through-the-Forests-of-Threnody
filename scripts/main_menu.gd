extends CanvasLayer

@onready var main_menu = $Menu
@onready var job_board = $"Job Board"
@onready var shop = $Shop
@onready var money1 = $"Job Board/MarginContainer/VBoxContainer/MarginContainer/MarginContainer/Money Counter"
@onready var money2 = $"Shop/MarginContainer/VBoxContainer/MarginContainer/Money Counter"
@onready var upgrades = $"Shop/MarginContainer/VBoxContainer/MarginContainer/MarginContainer/Upgrade List/RichTextLabel"

# The point of this is to be able to tell if the player just
#  launched the game or not, if yes -> main menu, if no -> job board
func _ready() -> void:
	if Globals.first_launched:
		Globals.first_launched = false
	else:
		main_menu.hide()
		job_board.show()

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		_menu_button()

func _menu_button():
	job_board.hide()
	shop.hide()
	main_menu.show()
	money1._update_money()
	money2._update_money()

func _shop_button():
	job_board.hide()
	shop.show()
	main_menu.hide()
	money1._update_money()
	money2._update_money()
	upgrades._update()
	
func _job_button():
	job_board.show()
	shop.hide()
	main_menu.hide()
	money1._update_money()
	money2._update_money()
	
