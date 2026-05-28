extends Button

var level: Dictionary
var mission_box: RichTextLabel
var connected := 0

var descriptions:= {"Family Emergency": "This will be an easy one, someone's family is in trouble and they need to get word beyond the silver. \n\nThey need word delivered fast, before nightfall makes things worse. \n\nYou shouldn’t run into many shades if you keep moving, but be quick.",
					"Fee Retrieval": "A simple collection job, someone forgot (or refused) to pay their due. \n\nHead out, collect what’s owed, and get back before they shut the gates. No trouble expected, but you know how it is in hell.",
					"Express Ale Delivery": "A tavern’s run dry at a popular waystop, and their regulars are getting restless. \n\nThey’re paying well to get a fresh shipment through the forest quickly. \n\nKeep your head up, and maybe dont shake the keg too much, No one likes flat ale.",
					"Express Food Shipment": "Supplies are running low in a homestead deeper in the forest. \n\nThey need food delivered before their companions get... desperate. \n\nIt’s a straightforward run.",
					"Silver Delivery": "This one's more serious, a military base is seeing friends they ain't seen in a while float through\n\nThey need silver. \n\nThe route is longer, and shades are more likely from the warfront.",
					"Ember Delivery": "Someones had a fire go out in the forest. \n\nI guess it's easier to have a prelit flame shipped out than deal with your grandma trying to kill you. \n\nGet them the flame there, be wary of the attention it'll bring you.",
					"Medical Emergency": "Someone’s dying out there, and they don’t have time to wait. \n\nYou’ll need to move fast, faster than is safe. \n\nThe Shadows are seeing red, be careful out their, friend.",
					"Corpse Retrieval": "A body is drawing unwanted attention in the forest. Someone powerful wants it gone. You know the attention bodies bring. \n\nBe fast, your life depends on it.",
					"Explosion First Response": "There was an explosion in the forest. You’re to reach the site, assess what’s left, and report back—if you can. \n\nExpect flames, freshly lit.",
					"Rescue Operation": "Someone’s still alive out there, stranded beyond the silver ways. \n\nYour job is to find them and bring them back alive. \n\nThis won’t be quick, and they'll no doubt have brought company.",
					"Shade-bound Letter": "A letter meant for someone who’s already dead. \n\nThe sender insists it be delivered to a marked place in the forest. \n\nJust run and leave it where instructed."}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mission_box = get_parent().get_parent().get_child(2).get_child(0)

func _on_pressed():
	# This uses the button text as a key, kinda fun but I doubt this is 'good' game design
	mission_box.set_text(descriptions[text])
	mission_box.get_child(0).show()
	Globals.current_level = level
	

func _process(_delta: float):
	if connected == 0:
		connected = 1
		connect("pressed", _on_pressed)
