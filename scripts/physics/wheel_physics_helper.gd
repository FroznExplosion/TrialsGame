class_name WheelPhysicsHelper
## Helper functions for wheel physics calculations
## Used by wheel.gd for force calculations

const PhysicsConstants = preload("res://scripts/physics/physics_constants.gd")

## Calculate tire force based on slip and normal force
static func calculate_tire_force(slip_velocity: Vector3, normal_force: float, friction_coefficient: float) -> Vector3:
	if slip_velocity.length() < 0.01:
		return Vector3.ZERO

	# Simplified Pacejka tire model
	var slip_direction = slip_velocity.normalized()
	var slip_magnitude = slip_velocity.length()

	# Maximum friction force (Coulomb friction)
	var max_friction = normal_force * friction_coefficient

	# Apply force opposite to slip direction
	var friction_force = slip_direction * -max_friction

	return friction_force

## Calculate rolling resistance
static func calculate_rolling_resistance(velocity: Vector3, normal_force: float) -> Vector3:
	if velocity.length() < 0.01:
		return Vector3.ZERO

	var resistance_force = velocity.normalized() * -PhysicsConstants.TIRE_ROLLING_RESISTANCE * normal_force
	return resistance_force

## Calculate angular velocity from linear velocity (for wheel rotation)
static func linear_to_angular_velocity(linear_velocity: float, wheel_radius: float) -> float:
	if wheel_radius < 0.01:
		return 0.0
	return linear_velocity / wheel_radius

## Calculate linear velocity from angular velocity
static func angular_to_linear_velocity(angular_velocity: float, wheel_radius: float) -> float:
	return angular_velocity * wheel_radius

## Calculate slip ratio (for advanced tire models)
static func calculate_slip_ratio(wheel_velocity: float, ground_velocity: float) -> float:
	if abs(ground_velocity) < 0.01:
		return 0.0
	return (wheel_velocity - ground_velocity) / abs(ground_velocity)
