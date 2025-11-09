extends Node

## LevelManager - Handles level loading, saving, and browsing
## Manages both built-in and custom user-created levels

signal level_loaded(level_data: Dictionary)
signal level_saved(file_path: String)
signal level_list_updated()

const CUSTOM_LEVELS_PATH = "user://levels/custom/"
const DEFAULT_LEVELS_PATH = "res://levels/default/"

var current_level: Dictionary = {}
var available_levels: Array[Dictionary] = []

func _ready():
	print("LevelManager initialized")

	# Ensure custom levels directory exists
	var dir = DirAccess.open("user://")
	if dir:
		if not dir.dir_exists("levels"):
			dir.make_dir("levels")
		if not dir.dir_exists("levels/custom"):
			dir.make_dir("levels/custom")

	# Load available levels list
	refresh_level_list()

func refresh_level_list():
	available_levels.clear()

	# Load default levels
	load_levels_from_directory(DEFAULT_LEVELS_PATH, "default")

	# Load custom levels
	load_levels_from_directory(CUSTOM_LEVELS_PATH, "custom")

	level_list_updated.emit()
	print("Found %d levels" % available_levels.size())

func load_levels_from_directory(path: String, category: String):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".json"):
				var level_info = load_level_metadata(path + file_name)
				if level_info:
					level_info["category"] = category
					level_info["file_path"] = path + file_name
					available_levels.append(level_info)
			file_name = dir.get_next()
		dir.list_dir_end()

func load_level_metadata(file_path: String) -> Dictionary:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		push_error("Failed to open level file: " + file_path)
		return {}

	var json_string = file.get_as_text()
	file.close()

	var json = JSON.new()
	var error = json.parse(json_string)
	if error != OK:
		push_error("Failed to parse JSON in: " + file_path)
		return {}

	return json.data

func load_level(file_path: String) -> Dictionary:
	var level_data = load_level_metadata(file_path)
	if level_data:
		current_level = level_data
		level_loaded.emit(level_data)
	return level_data

func save_level(level_data: Dictionary, file_name: String = "") -> bool:
	if file_name.is_empty():
		# Generate file name from level name
		var level_name = level_data.get("name", "Untitled")
		file_name = level_name.to_snake_case() + ".json"

	if not file_name.ends_with(".json"):
		file_name += ".json"

	var file_path = CUSTOM_LEVELS_PATH + file_name

	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if not file:
		push_error("Failed to save level to: " + file_path)
		return false

	var json_string = JSON.stringify(level_data, "\t")
	file.store_string(json_string)
	file.close()

	level_saved.emit(file_path)
	refresh_level_list()

	print("Level saved to: " + file_path)
	return true

func delete_level(file_path: String) -> bool:
	# Only allow deleting custom levels
	if not file_path.begins_with(CUSTOM_LEVELS_PATH):
		push_error("Cannot delete built-in levels")
		return false

	var dir = DirAccess.open(CUSTOM_LEVELS_PATH)
	if dir:
		if dir.file_exists(file_path):
			dir.remove(file_path)
			refresh_level_list()
			return true

	return false

func get_level_list(category: String = "") -> Array[Dictionary]:
	if category.is_empty():
		return available_levels

	var filtered = []
	for level in available_levels:
		if level.get("category", "") == category:
			filtered.append(level)

	return filtered

func create_empty_level() -> Dictionary:
	return {
		"name": "Untitled Level",
		"author": "Unknown",
		"version": 1,
		"created_date": Time.get_datetime_string_from_system(),
		"difficulty": "Medium",
		"path_points": [],
		"track_width": 3.0,
		"track_material": "default",
		"start_position": Vector3(0, 1, 0),
		"checkpoints": [],
		"obstacles": [],
		"decorations": [],
		"metadata": {}
	}
