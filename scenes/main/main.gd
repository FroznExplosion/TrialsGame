extends Node3D

## Main game scene controller
## Handles game initialization and scene management

@onready var bike: Node3D = null
@ontml:parameter name="camera">
@onready var game_camera: Camera3D = null
@onready var track: Node3D = null
@onready var hud: Control = null

func _ready():
	print("Main scene loaded")

	# Initialize game systems
	setup_game()

func setup_game():
	# Wait for autoloads to be ready
	await get_tree().process_frame

	# Load default settings
	if SettingsManager:
		SettingsManager.apply_all_settings()

	# Show menu or start game based on game state
	if GameManager.current_state == GameManager.GameState.MENU:
		# TODO: Show main menu when UI is implemented
		pass

func start_game(level_data: Dictionary):
	if GameManager:
		GameManager.start_level(level_data)

	# Spawn bike at start position
	spawn_bike(level_data.get("start_position", Vector3(0, 1, 0)))

func spawn_bike(position: Vector3):
	# TODO: Instantiate bike scene when it's created
	# bike = BikeScene.instantiate()
	# bike.global_position = position
	# add_child(bike)
	pass

func _input(event):
	# Handle pause
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause():
	if GameManager.current_state == GameManager.GameState.PLAYING:
		GameManager.pause_game()
	elif GameManager.current_state == GameManager.GameState.PAUSED:
		GameManager.resume_game()
