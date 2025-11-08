extends Node

## InputManager - Cross-platform input abstraction
## Handles keyboard, mouse, gamepad, and touch input

signal input_scheme_changed(scheme: InputScheme)

enum InputScheme {
	KEYBOARD_MOUSE,
	GAMEPAD,
	TOUCH
}

var current_scheme: InputScheme = InputScheme.KEYBOARD_MOUSE
var previous_scheme: InputScheme = InputScheme.KEYBOARD_MOUSE

# Input values (normalized 0.0 to 1.0, or -1.0 to 1.0 for lean)
var throttle: float = 0.0
var brake: float = 0.0
var lean: float = 0.0
var reset_pressed: bool = false

# Touch controls reference (set by mobile_controls scene)
var touch_controls: Control = null

func _ready():
	print("InputManager initialized")

	# Auto-detect platform
	if OS.has_feature("mobile") or OS.has_feature("web_android") or OS.has_feature("web_ios"):
		current_scheme = InputScheme.TOUCH

	# Listen for controller connection changes
	Input.joy_connection_changed.connect(_on_joy_connection_changed)

func _process(_delta):
	# Update input based on current scheme
	match current_scheme:
		InputScheme.KEYBOARD_MOUSE:
			update_keyboard_input()
		InputScheme.GAMEPAD:
			update_gamepad_input()
		InputScheme.TOUCH:
			update_touch_input()

	# Auto-detect scheme changes (keyboard/gamepad)
	detect_input_scheme_change()

func update_keyboard_input():
	# Throttle: W, Up Arrow, or Space
	throttle = 1.0 if Input.is_action_pressed("throttle") else 0.0

	# Brake: S or Down Arrow
	brake = 1.0 if Input.is_action_pressed("brake") else 0.0

	# Lean: A/D or Left/Right arrows (-1 = back, +1 = forward)
	lean = Input.get_axis("lean_back", "lean_forward")

	# Reset: R key
	reset_pressed = Input.is_action_just_pressed("reset")

func update_gamepad_input():
	# Right trigger (RT): Throttle
	throttle = Input.get_action_strength("gamepad_throttle")

	# Left trigger (LT): Brake
	brake = Input.get_action_strength("gamepad_brake")

	# Left stick horizontal: Lean
	lean = Input.get_axis("gamepad_lean_back", "gamepad_lean_forward")

	# B button (Xbox) / Circle (PS): Reset
	reset_pressed = Input.is_action_just_pressed("gamepad_reset")

func update_touch_input():
	# Touch input is set by mobile_controls.gd via setter methods
	# This function can be used for additional touch processing if needed
	pass

## Touch input setters (called by mobile UI)

func set_touch_throttle(value: float):
	throttle = clamp(value, 0.0, 1.0)

func set_touch_brake(value: float):
	brake = clamp(value, 0.0, 1.0)

func set_touch_lean(value: float):
	lean = clamp(value, -1.0, 1.0)

func set_touch_reset():
	reset_pressed = true

## Input value getters (used by bike_controller.gd)

func get_throttle() -> float:
	return throttle

func get_brake() -> float:
	return brake

func get_lean() -> float:
	return lean

func is_reset_pressed() -> bool:
	var was_pressed = reset_pressed
	reset_pressed = false  # Reset flag after reading
	return was_pressed

## Input scheme detection

func detect_input_scheme_change():
	# Don't auto-switch if using touch controls
	if current_scheme == InputScheme.TOUCH and not OS.has_feature("mobile"):
		# Allow switching away from touch on desktop
		pass

	# Detect keyboard input
	if Input.is_anything_pressed() and current_scheme != InputScheme.KEYBOARD_MOUSE:
		for action in ["throttle", "brake", "lean_back", "lean_forward"]:
			if Input.is_action_pressed(action):
				var events = InputMap.action_get_events(action)
				for event in events:
					if event is InputEventKey:
						change_scheme(InputScheme.KEYBOARD_MOUSE)
						return

	# Detect gamepad input
	if Input.get_connected_joypads().size() > 0:
		for action in ["gamepad_throttle", "gamepad_brake", "gamepad_lean_back", "gamepad_lean_forward"]:
			if Input.is_action_pressed(action):
				change_scheme(InputScheme.GAMEPAD)
				return

func change_scheme(new_scheme: InputScheme):
	if new_scheme != current_scheme:
		previous_scheme = current_scheme
		current_scheme = new_scheme
		input_scheme_changed.emit(new_scheme)
		print("Input scheme changed to: ", InputScheme.keys()[new_scheme])

func _on_joy_connection_changed(device: int, connected: bool):
	if connected:
		change_scheme(InputScheme.GAMEPAD)
	else:
		# If no gamepads connected, switch to keyboard (unless on mobile)
		if Input.get_connected_joypads().size() == 0:
			if not OS.has_feature("mobile"):
				change_scheme(InputScheme.KEYBOARD_MOUSE)
