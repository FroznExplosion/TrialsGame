extends Node

## SettingsManager - User preferences and game settings
## Handles graphics, audio, controls, and platform-specific optimizations

signal settings_changed(setting_name: String, value: Variant)

const SETTINGS_FILE = "user://settings.cfg"

# Default settings
var settings: Dictionary = {
	# Graphics
	"graphics_quality": "High",  # Low, Medium, High, Ultra
	"vsync": true,
	"fps_limit": 60,
	"msaa": 2,  # 0=Off, 2=2x, 4=4x, 8=8x
	"fxaa": false,

	# Audio
	"master_volume": 1.0,
	"music_volume": 0.7,
	"sfx_volume": 0.8,

	# Controls
	"gamepad_vibration": true,
	"touch_controls_opacity": 0.7,

	# Gameplay
	"show_fps": false,
	"camera_shake": true,

	# Platform
	"is_mobile_optimized": false
}

func _ready():
	print("SettingsManager initialized")
	load_settings()
	apply_all_settings()

	# Auto-detect mobile and apply optimizations
	if OS.has_feature("mobile") or OS.has_feature("web_android") or OS.has_feature("web_ios"):
		apply_mobile_optimizations()

func load_settings():
	var config = ConfigFile.new()
	var error = config.load(SETTINGS_FILE)

	if error == OK:
		for section in config.get_sections():
			for key in config.get_section_keys(section):
				var full_key = key if section == "general" else section + "_" + key
				settings[full_key] = config.get_value(section, key)
		print("Settings loaded from: " + SETTINGS_FILE)
	else:
		print("No settings file found, using defaults")

func save_settings():
	var config = ConfigFile.new()

	# Organize settings into sections
	for key in settings.keys():
		var section = "general"
		var setting_key = key

		if key.begins_with("graphics_"):
			section = "graphics"
			setting_key = key.replace("graphics_", "")
		elif key.begins_with("audio_") or key.ends_with("_volume"):
			section = "audio"
			setting_key = key.replace("audio_", "").replace("_volume", "")
		elif key.begins_with("gamepad_") or key.begins_with("touch_"):
			section = "controls"
			setting_key = key

		config.set_value(section, setting_key, settings[key])

	var error = config.save(SETTINGS_FILE)
	if error == OK:
		print("Settings saved to: " + SETTINGS_FILE)
	else:
		push_error("Failed to save settings: " + str(error))

func get_setting(key: String, default_value: Variant = null) -> Variant:
	return settings.get(key, default_value)

func set_setting(key: String, value: Variant):
	settings[key] = value
	apply_setting(key, value)
	settings_changed.emit(key, value)

func apply_all_settings():
	for key in settings.keys():
		apply_setting(key, settings[key])

func apply_setting(key: String, value: Variant):
	match key:
		"vsync":
			if value:
				DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
			else:
				DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

		"fps_limit":
			Engine.max_fps = value as int

		"msaa":
			var viewport = get_viewport()
			if viewport:
				match value:
					0: viewport.msaa_3d = Viewport.MSAA_DISABLED
					2: viewport.msaa_3d = Viewport.MSAA_2X
					4: viewport.msaa_3d = Viewport.MSAA_4X
					8: viewport.msaa_3d = Viewport.MSAA_8X

		"master_volume":
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))

		"music_volume":
			var bus_idx = AudioServer.get_bus_index("Music") if AudioServer.get_bus_index("Music") != -1 else 0
			AudioServer.set_bus_volume_db(bus_idx, linear_to_db(value))

		"sfx_volume":
			var bus_idx = AudioServer.get_bus_index("SFX") if AudioServer.get_bus_index("SFX") != -1 else 0
			AudioServer.set_bus_volume_db(bus_idx, linear_to_db(value))

func apply_mobile_optimizations():
	if settings.get("is_mobile_optimized", false):
		return  # Already optimized

	print("Applying mobile optimizations...")

	# Graphics
	set_setting("graphics_quality", "Low")
	set_setting("msaa", 0)
	set_setting("fxaa", false)
	set_setting("fps_limit", 30)

	# Physics
	ProjectSettings.set_setting("physics/3d/physics_ticks_per_second", 30)
	ProjectSettings.set_setting("physics/3d/sleep_threshold_linear", 0.2)
	ProjectSettings.set_setting("physics/3d/sleep_threshold_angular", 0.3)

	settings["is_mobile_optimized"] = true
	save_settings()

	print("Mobile optimizations applied")

func apply_graphics_quality(quality: String):
	match quality:
		"Low":
			set_setting("msaa", 0)
			set_setting("fxaa", false)
		"Medium":
			set_setting("msaa", 0)
			set_setting("fxaa", true)
		"High":
			set_setting("msaa", 2)
			set_setting("fxaa", false)
		"Ultra":
			set_setting("msaa", 4)
			set_setting("fxaa", true)

	set_setting("graphics_quality", quality)
	save_settings()
