extends VBoxContainer

@onready var silver = $Silver
@onready var pewter = $Pewter
@onready var Magnesium = $Magnesium
@onready var Aluminum = $Aluminum
@onready var description = $"../MarginContainer/Item Description"
@onready var money = $"../../Money Counter"
@onready var upgrades = $"../Upgrade List/RichTextLabel"
@onready var buy = $"../MarginContainer/Item Description/Buy Button"

@export var silver_cost: int = 10
@export var pewter_cost: int = 5
@export var magnesium_cost: int = 20
@export var aluminum_cost: int = 20

@export var silver_max: int = 3
@export var pewter_max: int = 5
@export var magnesium_max: int = 3
@export var aluminum_max: int = 10

var cost_dict := {Globals.SILVER: silver_cost, Globals.PEWTER: pewter_cost,
				 Globals.MAGNESIUM: magnesium_cost, Globals.ALUMINUM: aluminum_cost}
var selected = Globals.NONE

func _silver():
	# Player can't buy a new knife if their's has silver still
	if Globals.silver <= 0:
		buy.show()
		description.text = "Silver weapon, can be used to cut down shades you can't avoid.\n This has limited uses, be careful not to burn it all out mid run.\nUse J or Q button to swing your weapon"
		selected = Globals.SILVER
	else:
		buy.hide()
		selected = Globals.NONE
		description.text = "You're weapon's still got good silver left, maybe reinforce it with some pewter instead."


func _pewter():
	if Globals.pewter < pewter_max && Globals.silver > 0:
		buy.show()
		description.text = "We can reinforce your silver weaponry with pewter bracings, it'll take the damage from the shades instead of the silver.\n\nBest to burn pewter instead of silver. "
		selected = Globals.PEWTER
	elif Globals.silver <= 0:
		buy.hide()
		selected = Globals.NONE
		description.text = "We can reinforce your silver weaponry with pewter bracings, it'll take the damage from the shades instead of the silver.\n\nBest to burn pewter instead of silver. \n\nYou need to buy a silver weapon before we can put pewter on it. "
	else:
		buy.hide()
		selected = Globals.NONE
		description.text = "You've got as much pewter as we can fit on that weapon, any more and you'll just be swinging a rock at the shades."

func _magnesium():
	if Globals.magnesium < magnesium_max:
		buy.show()
		description.text = "Magnesium grenades. Their blinding bright light draws the shades away from people, but they only last so long. \n These are incredibly helpful in avoiding the shadows, but be careful not to draw a shadow into your path.\n Use K or E button to throw a grenade"
		selected = Globals.MAGNESIUM
	else:
		buy.hide()
		selected = Globals.NONE
		description.text = "Any more magnesium in that pack and you wont be able to run anymore."


func _aluminum():
	if Globals.aluminum < aluminum_max:
		buy.show()
		description.text = "Aluminum-lined clothing, it makes it harder for shades to notice you.\n\n Unfortunately it's extremely difficult to refine."
		selected = Globals.ALUMINUM
	else:
		buy.hide()
		selected = Globals.NONE
		description.text = "Any more aluminum wont have any effect. Save your money."

func _buy():
	if selected != Globals.NONE:
		match selected:
			Globals.SILVER:
				if Globals.money >= silver_cost * silver_max:
					Globals.money -= silver_cost * silver_max
					Globals.silver = silver_max
					_silver()
					money._update_money()
					upgrades._update()
			
			Globals.PEWTER:
				if Globals.money >= pewter_cost:
					Globals.money -= pewter_cost
					Globals.pewter += 1
					_pewter()
					money._update_money()
					upgrades._update()
			
			Globals.MAGNESIUM:
				if Globals.money >= magnesium_cost:
					Globals.money -= magnesium_cost
					Globals.magnesium += 1
					_magnesium()
					money._update_money()
					upgrades._update()
			
			Globals.ALUMINUM:
				if Globals.money >= aluminum_cost:
					Globals.money -= aluminum_cost
					Globals.aluminum += 1
					_aluminum()
					money._update_money()
					upgrades._update()
