class_name SpringDamper
## Spring-Damper physics calculator
## Used for suspension simulation

var spring_rate: float
var damper_rate: float
var rest_length: float
var max_travel: float

var current_compression: float = 0.0
var compression_velocity: float = 0.0
var previous_length: float = 0.0

func _init(spring: float, damper: float, rest: float, travel: float):
	spring_rate = spring
	damper_rate = damper
	rest_length = rest
	max_travel = travel
	previous_length = rest

func calculate_force(current_length: float, delta: float) -> float:
	# Calculate compression from rest position
	current_compression = rest_length - current_length
	current_compression = clamp(current_compression, 0.0, max_travel)

	# Calculate compression velocity
	compression_velocity = (previous_length - current_length) / delta if delta > 0 else 0.0
	previous_length = current_length

	# Spring force: F = -k * x (Hooke's law)
	var spring_force = spring_rate * current_compression

	# Damper force: F = -c * v
	var damper_force = damper_rate * compression_velocity

	# Total force (always positive, pushes back)
	return spring_force + damper_force

func get_compression_ratio() -> float:
	return current_compression / max_travel if max_travel > 0 else 0.0

func reset():
	current_compression = 0.0
	compression_velocity = 0.0
	previous_length = rest_length
