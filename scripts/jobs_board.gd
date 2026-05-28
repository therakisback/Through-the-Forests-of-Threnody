extends VBoxContainer

var titles := {1: ["Family Emergency", "Fee Retrieval", "Express Ale Delivery", "Express Food Shipment"],
			   2: ["Silver Delivery", "Ember Delivery"],
			   3: ["Medical Emergency", "Corpse Retrieval", "Explosion First Response", "Rescue Operation"]}

var used_titles: Array
var button_path := preload("res://scenes/job_button.tscn")

func _ready() -> void:
	$"../MarginContainer/MissionDescription".text = Globals.default_text
	
	Globals.generate_levels()
	var levels = Globals.levels
	used_titles = [""]
	
	for level in levels:
		var button: Button = button_path.instantiate()
		# Define the main text of the button
		var title: String = ""
		var difficulty_text: String
		var payout_text: String

		match level['difficulty']:
			1,2 :
				while used_titles.has(title):
					title = titles[1][randi() % titles[1].size()]
				difficulty_text = "Easy"
				payout_text = "Low"
			3,4:
				while used_titles.has(title):
					title = titles[2][randi() % titles[2].size()]
				difficulty_text = "Modest"
				payout_text = "Fair"
			5:
				while used_titles.has(title):
					title = titles[3][randi() % titles[3].size()]
				difficulty_text = "Hard"
				payout_text = "High"
			6: 
				while used_titles.has(title):
					title = titles[3][randi() % titles[3].size()]
				difficulty_text = "Hell"
				payout_text = "Extreme"
		
		used_titles.append(title)
		
		button.text = title
		button.flat = true
		button.level = level
		add_child(button)
		
		var button_desc := RichTextLabel.new()
		var text := ("Difficulty: %s \t Payout: %s \n" % [difficulty_text, payout_text])
		print("desc text: ", text)
		button_desc.text= text
		button_desc.scroll_active = false
		button_desc.fit_content = true
		button_desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		add_child(button_desc)

func _start_mission():
	get_tree().change_scene_to_file("res://scenes/world.tscn")
