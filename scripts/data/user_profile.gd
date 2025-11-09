class_name UserProfile
extends Resource

## User profile data
## Saves player progress, settings, and statistics

@export var player_name: String = "Player"
@export var created_date: String = ""
@export var last_played: String = ""

# Progress
@export var levels_completed: Array[String] = []  # Level file names
@export var total_play_time: float = 0.0  # seconds
@export var total_faults: int = 0
@export var total_crashes: int = 0

# Level records (level_name -> best_time)
@export var level_best_times: Dictionary = {}
@export var level_medals: Dictionary = {}  # level_name -> medal (gold/silver/bronze)

# Unlocks
@export var unlocked_bikes: Array[String] = ["Default Bike"]
@export var selected_bike: String = "Default Bike"

# Statistics
@export var total_distance: float = 0.0  # meters
@export var highest_speed: float = 0.0  # m/s
@export var longest_jump: float = 0.0  # meters
@export var total_flips: int = 0

# Custom levels
@export var created_levels: Array[String] = []  # File names of user-created levels
@export var favorite_levels: Array[String] = []

# Achievements
@export var achievements: Array[String] = []

const SAVE_PATH = "user://profile.tres"

func _init():
	created_date = Time.get_datetime_string_from_system()
	last_played = created_date

func save_profile() -> bool:
	last_played = Time.get_datetime_string_from_system()
	var error = ResourceSaver.save(self, SAVE_PATH)
	if error == OK:
		print("Profile saved successfully")
		return true
	else:
		push_error("Failed to save profile: " + str(error))
		return false

static func load_profile() -> UserProfile:
	if ResourceLoader.exists(SAVE_PATH):
		var profile = ResourceLoader.load(SAVE_PATH) as UserProfile
		if profile:
			profile.last_played = Time.get_datetime_string_from_system()
			print("Profile loaded successfully")
			return profile
		else:
			push_error("Failed to load profile")

	# Create new profile if doesn't exist
	print("Creating new profile")
	return UserProfile.new()

func complete_level(level_name: String, time: float, faults: int):
	if level_name not in levels_completed:
		levels_completed.append(level_name)

	# Update best time
	if level_name not in level_best_times or time < level_best_times[level_name]:
		level_best_times[level_name] = time

	# Calculate medal
	var medal = calculate_medal(time, faults)
	if level_name not in level_medals or is_better_medal(medal, level_medals[level_name]):
		level_medals[level_name] = medal

	total_faults += faults

	save_profile()

func calculate_medal(time: float, faults: int) -> String:
	# Simple medal calculation (should be customized per level)
	if faults == 0 and time < 30.0:
		return "gold"
	elif faults < 3 and time < 60.0:
		return "silver"
	elif time < 120.0:
		return "bronze"
	return "none"

func is_better_medal(new_medal: String, old_medal: String) -> bool:
	const medal_values = {"gold": 3, "silver": 2, "bronze": 1, "none": 0}
	return medal_values.get(new_medal, 0) > medal_values.get(old_medal, 0)

func unlock_bike(bike_name: String):
	if bike_name not in unlocked_bikes:
		unlocked_bikes.append(bike_name)
		save_profile()

func select_bike(bike_name: String):
	if bike_name in unlocked_bikes:
		selected_bike = bike_name
		save_profile()

func add_achievement(achievement_id: String):
	if achievement_id not in achievements:
		achievements.append(achievement_id)
		save_profile()
		return true
	return false

func update_statistics(distance: float, speed: float, crashes: int):
	total_distance += distance
	highest_speed = max(highest_speed, speed)
	total_crashes += crashes

func add_created_level(level_file: String):
	if level_file not in created_levels:
		created_levels.append(level_file)
		save_profile()

func toggle_favorite(level_file: String):
	if level_file in favorite_levels:
		favorite_levels.erase(level_file)
	else:
		favorite_levels.append(level_file)
	save_profile()
