extends Node

# Global player variables
var score: int = 30
var money := score
var difficulty_step: int = 50
# Abilities & upgrades
enum {SILVER, PEWTER, MAGNESIUM, ALUMINUM, NONE}
var magnesium: int = 0
var aluminum: int = 0
var notice_modifier = 1

var silver: int = 0
var silver_range: int = 0
var pewter: int = 0

var equipped = NONE

# Level variables
# We just initialize with default values for testing
var current_level: Dictionary = {
	'time': 22, 'shade': 400, 
	'tree': 300, 'width': 128.0,
	'length': 512.0, 'height': 28.0,
	'difficulty': 0, 'speed': 10,
	'notice': 1
}
var levels := []
var player_pos: Vector3 = Vector3(0, 0, 0)
var game_ready: bool = false
var default_text = "Welcome\n\nGear up and pick a job.\n\n Make sure you're able to handle it. \n\n A or left arrow to move left, D or right arrow to move right"
var first_launched: bool = true

# Generates a set of three new level's stats for the job selector
func generate_levels():
	levels = []
	
	# We need to define the minimum level difficulty based on how much they've played
	var min_difficulty: int
	if score < difficulty_step:
		min_difficulty = 1
	elif score < difficulty_step * 2:
		min_difficulty = 2
	elif score <difficulty_step * 3:
		min_difficulty = 3
	else:
		min_difficulty = 4
	
	# We are going to create three levels of increasing difficulty
	# It will max out at 6 for now.
	levels.append(_new_level(min_difficulty))
	levels.append(_new_level(min_difficulty + 1))
	levels.append(_new_level(min_difficulty + 2))
	
	

func _new_level(difficulty: int) -> Dictionary:
	# I can add more features here for level generation
	# Remanant of randomly selected time, I have made it close to midnight for atmosphere
	var time_of_day: float
	time_of_day = 22
	
	# We are going to create some amount of shades based on difficulty
	var shade_count: int
	shade_count = 100 * difficulty
	
	# Too many trees prevents player movement, so we will use sqrt function
	var tree_count: int
	@warning_ignore("narrowing_conversion")
	tree_count =300 * sqrt(difficulty)
	
	var terrain_width: float
	terrain_width = 256.0 / sqrt(difficulty)
	
	var terrain_length: float
	terrain_length = 256.0 * max(1, difficulty/2.0)
	
	# Also using sqrt here as terrain height becomes too much very quickly
	var terrain_height: float
	terrain_height = 8 * sqrt(difficulty)
	
	var player_speed: float
	player_speed = 8 + 1 * difficulty
	
	var notice_range: float
	# Notice range has to be minimum 1
	notice_range = 1 + 0.1*difficulty
	
	return {'time': time_of_day, 'shade': shade_count, 
			'tree': tree_count, 'width': terrain_width,
			'length': terrain_length, 'height': terrain_height,
			'difficulty': difficulty, 'speed': player_speed,
			'notice': notice_range}

func add_score(num: int):
	score += num
	money += num

func reset_score():
	score = 30
	money = score
	silver = 0
	pewter = 0
	magnesium = 0
	aluminum = 0
