extends Node

## GameManager - Singleton for managing game state
## Handles scene transitions, scoring, level state, and game flow

signal level_started()
signal level_completed(time: float, faults: int)
signal bike_crashed()
signal checkpoint_passed(checkpoint_id: int)

enum GameState {
	MENU,
	PLAYING,
	PAUSED,
	LEVEL_EDITOR,
	LEVEL_COMPLETE
}

var current_state: GameState = GameState.MENU
var current_level: Dictionary = {}
var current_time: float = 0.0
var faults: int = 0
var checkpoints_passed: Array[int] = []

func _ready():
	print("GameManager initialized")

func start_level(level_data: Dictionary):
	current_level = level_data
	current_time = 0.0
	faults = 0
	checkpoints_passed.clear()
	current_state = GameState.PLAYING
	level_started.emit()

func complete_level():
	current_state = GameState.LEVEL_COMPLETE
	level_completed.emit(current_time, faults)

func reset_level():
	start_level(current_level)

func pause_game():
	current_state = GameState.PAUSED
	get_tree().paused = true

func resume_game():
	current_state = GameState.PLAYING
	get_tree().paused = false

func _process(delta):
	if current_state == GameState.PLAYING:
		current_time += delta

func _on_checkpoint_passed(checkpoint_id: int):
	if checkpoint_id not in checkpoints_passed:
		checkpoints_passed.append(checkpoint_id)
		checkpoint_passed.emit(checkpoint_id)

func _on_bike_crashed():
	faults += 1
	bike_crashed.emit()
