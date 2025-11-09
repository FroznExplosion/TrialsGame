class_name BikeStats
extends Resource

## Bike statistics and configuration
## Different bikes can have different stats

@export var bike_name: String = "Default Bike"
@export var description: String = "Standard trials bike"

# Physics properties
@export var mass: float = 100.0  # kg
@export var max_engine_torque: float = 300.0  # Nm
@export var max_brake_torque: float = 500.0  # Nm

# Suspension
@export var front_spring_rate: float = 12000.0  # N/m
@export var rear_spring_rate: float = 18000.0  # N/m
@export var front_damper_rate: float = 600.0  # Ns/m
@export var rear_damper_rate: float = 900.0  # Ns/m
@export var suspension_travel: float = 0.25  # meters

# Wheels
@export var wheel_radius: float = 0.35  # meters
@export var wheel_mass: float = 5.0  # kg each
@export var tire_grip: float = 1.5  # Friction multiplier

# Handling
@export var lean_speed: float = 3.0  # How fast rider shifts weight
@export var lean_torque_multiplier: float = 200.0  # Torque from lean

# Visual
@export var bike_mesh: Mesh = null
@export var bike_color: Color = Color.WHITE

# Unlock status
@export var is_unlocked: bool = true
@export var unlock_requirement: String = ""

func _init():
	bike_name = "Default Bike"

func apply_to_bike(bike_node: Node3D):
	# This would be called to apply stats to a bike instance
	# Implementation depends on bike structure
	pass

## Create some preset bikes

static func create_default_bike() -> BikeStats:
	var bike = BikeStats.new()
	bike.bike_name = "Default Bike"
	bike.description = "Well-balanced bike for all situations"
	return bike

static func create_lightweight_bike() -> BikeStats:
	var bike = BikeStats.new()
	bike.bike_name = "Lightweight"
	bike.description = "Lighter and more maneuverable"
	bike.mass = 85.0
	bike.lean_speed = 4.0
	bike.max_engine_torque = 250.0
	bike.tire_grip = 1.3
	return bike

static func create_power_bike() -> BikeStats:
	var bike = BikeStats.new()
	bike.bike_name = "Power"
	bike.description = "More power, heavier"
	bike.mass = 115.0
	bike.max_engine_torque = 400.0
	bike.tire_grip = 1.7
	bike.lean_speed = 2.5
	return bike

static func create_trial_expert_bike() -> BikeStats:
	var bike = BikeStats.new()
	bike.bike_name = "Trial Expert"
	bike.description = "Ultimate control for experts"
	bike.mass = 95.0
	bike.max_engine_torque = 350.0
	bike.tire_grip = 1.8
	bike.lean_speed = 5.0
	bike.front_spring_rate = 15000.0
	bike.rear_spring_rate = 20000.0
	bike.is_unlocked = false
	bike.unlock_requirement = "Complete 10 levels with gold medal"
	return bike
