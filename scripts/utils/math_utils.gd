class_name MathUtils
## Utility math functions
## Common mathematical operations used throughout the game

## Smooth interpolation with ease-in-ease-out
static func smooth_lerp(from: float, to: float, weight: float) -> float:
	var t = clamp(weight, 0.0, 1.0)
	t = t * t * (3.0 - 2.0 * t)  # Smoothstep
	return lerp(from, to, t)

## Vector3 smooth lerp
static func smooth_lerp_v3(from: Vector3, to: Vector3, weight: float) -> Vector3:
	return Vector3(
		smooth_lerp(from.x, to.x, weight),
		smooth_lerp(from.y, to.y, weight),
		smooth_lerp(from.z, to.z, weight)
	)

## Remap value from one range to another
static func remap(value: float, from_min: float, from_max: float, to_min: float, to_max: float) -> float:
	var normalized = (value - from_min) / (from_max - from_min)
	return lerp(to_min, to_max, normalized)

## Clamp angle to range [-180, 180]
static func normalize_angle(angle: float) -> float:
	while angle > 180.0:
		angle -= 360.0
	while angle < -180.0:
		angle += 360.0
	return angle

## Get shortest angle between two angles
static func angle_difference(from: float, to: float) -> float:
	var diff = to - from
	return normalize_angle(diff)

## Smooth damp (spring-like interpolation)
static func smooth_damp(current: float, target: float, current_velocity: float, smooth_time: float, delta: float) -> Dictionary:
	# Based on Game Programming Gems 4 Chapter 1.10
	smooth_time = max(0.0001, smooth_time)
	var omega = 2.0 / smooth_time
	var x = omega * delta
	var exp = 1.0 / (1.0 + x + 0.48 * x * x + 0.235 * x * x * x)

	var change = current - target
	var original_to = target

	var max_change = 9999999.0  # Effectively unlimited
	change = clamp(change, -max_change, max_change)
	target = current - change

	var temp = (current_velocity + omega * change) * delta
	var new_velocity = (current_velocity - omega * temp) * exp
	var new_value = target + (change + temp) * exp

	# Prevent overshooting
	if (original_to - current > 0.0) == (new_value > original_to):
		new_value = original_to
		new_velocity = (new_value - original_to) / delta

	return {
		"value": new_value,
		"velocity": new_velocity
	}

## Calculate signed angle between two vectors in a plane
static func signed_angle(from: Vector3, to: Vector3, normal: Vector3) -> float:
	var angle = from.angle_to(to)
	var cross = from.cross(to)
	if cross.dot(normal) < 0:
		angle = -angle
	return rad_to_deg(angle)

## Project vector onto plane
static func project_on_plane(vector: Vector3, plane_normal: Vector3) -> Vector3:
	var distance = vector.dot(plane_normal)
	return vector - plane_normal * distance

## Exponential decay (for smoothing)
static func exp_decay(a: float, b: float, decay: float, delta: float) -> float:
	return b + (a - b) * exp(-decay * delta)

## Vector3 exponential decay
static func exp_decay_v3(a: Vector3, b: Vector3, decay: float, delta: float) -> Vector3:
	return Vector3(
		exp_decay(a.x, b.x, decay, delta),
		exp_decay(a.y, b.y, decay, delta),
		exp_decay(a.z, b.z, decay, delta)
	)

## Check if value is approximately zero
static func is_zero_approx_custom(value: float, epsilon: float = 0.00001) -> bool:
	return abs(value) < epsilon

## Safe normalize (returns zero vector if length is too small)
static func safe_normalize(vector: Vector3, epsilon: float = 0.00001) -> Vector3:
	var length_squared = vector.length_squared()
	if length_squared < epsilon * epsilon:
		return Vector3.ZERO
	return vector / sqrt(length_squared)

## Spring force calculation
static func calculate_spring_force(displacement: float, velocity: float, spring_constant: float, damping: float) -> float:
	return -spring_constant * displacement - damping * velocity

## Calculate centripetal force
static func calculate_centripetal_force(mass: float, velocity: float, radius: float) -> float:
	if radius < 0.001:
		return 0.0
	return mass * velocity * velocity / radius
