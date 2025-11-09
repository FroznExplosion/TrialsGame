class_name LevelData
extends Resource

## Level data structure for saving/loading levels
## Contains all information needed to reconstruct a level

@export var level_name: String = "Untitled Level"
@export var author: String = "Unknown"
@export var version: int = 1
@export var created_date: String = ""
@export var modified_date: String = ""
@export var difficulty: String = "Medium"  # Easy, Medium, Hard, Expert

# Track data
@export var path_points: Array[Vector3] = []
@export var track_width: float = 3.0
@export var track_material: String = "default"
@export var smoothing_strength: float = 0.5

# Gameplay elements
@export var start_position: Vector3 = Vector3(0, 1, 0)
@export var start_rotation: Vector3 = Vector3(0, 0, 0)
@export var finish_position: Vector3 = Vector3(0, 0, 0)

# Checkpoints
@export var checkpoints: Array[Dictionary] = []  # {position: Vector3, rotation: Vector3}

# Objects (obstacles, ramps, decorations)
@export var obstacles: Array[Dictionary] = []  # {type: String, position: Vector3, rotation: Vector3, scale: Vector3}
@export var decorations: Array[Dictionary] = []

# Environment settings
@export var gravity: float = 20.0
@export var background_color: Color = Color(0.4, 0.6, 1.0)
@export var fog_enabled: bool = false

# Metadata
@export var best_time: float = 0.0
@export var play_count: int = 0
@export var tags: Array[String] = []

func _init():
	created_date = Time.get_datetime_string_from_system()
	modified_date = created_date

func to_dictionary() -> Dictionary:
	return {
		"name": level_name,
		"author": author,
		"version": version,
		"created_date": created_date,
		"modified_date": modified_date,
		"difficulty": difficulty,
		"path_points": path_points,
		"track_width": track_width,
		"track_material": track_material,
		"smoothing_strength": smoothing_strength,
		"start_position": var_to_str(start_position),
		"start_rotation": var_to_str(start_rotation),
		"finish_position": var_to_str(finish_position),
		"checkpoints": checkpoints,
		"obstacles": obstacles,
		"decorations": decorations,
		"gravity": gravity,
		"background_color": background_color.to_html(),
		"fog_enabled": fog_enabled,
		"best_time": best_time,
		"play_count": play_count,
		"tags": tags
	}

static func from_dictionary(data: Dictionary) -> LevelData:
	var level = LevelData.new()

	level.level_name = data.get("name", "Untitled Level")
	level.author = data.get("author", "Unknown")
	level.version = data.get("version", 1)
	level.created_date = data.get("created_date", "")
	level.modified_date = data.get("modified_date", "")
	level.difficulty = data.get("difficulty", "Medium")

	# Convert path points from array
	var points_data = data.get("path_points", [])
	for point_data in points_data:
		if point_data is Vector3:
			level.path_points.append(point_data)
		elif point_data is String:
			level.path_points.append(str_to_var(point_data))

	level.track_width = data.get("track_width", 3.0)
	level.track_material = data.get("track_material", "default")
	level.smoothing_strength = data.get("smoothing_strength", 0.5)

	# Parse Vector3 strings
	var start_pos = data.get("start_position", "Vector3(0, 1, 0)")
	level.start_position = str_to_var(start_pos) if start_pos is String else start_pos

	var start_rot = data.get("start_rotation", "Vector3(0, 0, 0)")
	level.start_rotation = str_to_var(start_rot) if start_rot is String else start_rot

	var finish_pos = data.get("finish_position", "Vector3(0, 0, 0)")
	level.finish_position = str_to_var(finish_pos) if finish_pos is String else finish_pos

	level.checkpoints = data.get("checkpoints", [])
	level.obstacles = data.get("obstacles", [])
	level.decorations = data.get("decorations", [])

	level.gravity = data.get("gravity", 20.0)

	var bg_color = data.get("background_color", "#6699FF")
	level.background_color = Color(bg_color) if bg_color is String else bg_color

	level.fog_enabled = data.get("fog_enabled", false)
	level.best_time = data.get("best_time", 0.0)
	level.play_count = data.get("play_count", 0)
	level.tags = data.get("tags", [])

	return level

func update_modified_date():
	modified_date = Time.get_datetime_string_from_system()

func add_checkpoint(position: Vector3, rotation: Vector3 = Vector3.ZERO):
	checkpoints.append({
		"position": position,
		"rotation": rotation
	})
	update_modified_date()

func add_obstacle(type: String, position: Vector3, rotation: Vector3 = Vector3.ZERO, scale: Vector3 = Vector3.ONE):
	obstacles.append({
		"type": type,
		"position": position,
		"rotation": rotation,
		"scale": scale
	})
	update_modified_date()

func clear_track():
	path_points.clear()
	checkpoints.clear()
	obstacles.clear()
	decorations.clear()
	update_modified_date()
