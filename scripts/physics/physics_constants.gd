extends Node

## Physics Constants - Tunable physics parameters for the bike
## Adjust these values to change how the bike feels

# Bike Properties
const BIKE_MASS = 100.0  # kg (bike only, rider separate)
const RIDER_MASS = 75.0  # kg
const TOTAL_MASS = BIKE_MASS + RIDER_MASS

# Wheel Properties
const WHEEL_RADIUS = 0.35  # meters (trials bike wheels ~0.35m)
const WHEEL_MASS = 5.0  # kg each
const WHEEL_WIDTH = 0.12  # meters

# Front/Rear wheel distribution
const FRONT_WHEEL_GRIP = 1.2  # Multiplier
const REAR_WHEEL_GRIP = 1.5  # Multiplier (more grip for power)

# Suspension (Spring-Damper)
const SPRING_RATE = 15000.0  # N/m (stiff for trials bike)
const DAMPER_RATE = 750.0  # Ns/m (SPRING_RATE / 20)
const SUSPENSION_TRAVEL = 0.25  # meters max compression
const SUSPENSION_REST_LENGTH = 0.3  # meters

# Front/Rear suspension differences
const FRONT_SPRING_MULTIPLIER = 0.8  # Softer front
const REAR_SPRING_MULTIPLIER = 1.2  # Stiffer rear

# Engine & Braking
const MAX_ENGINE_TORQUE = 300.0  # Nm (rear wheel only)
const MAX_BRAKE_TORQUE = 500.0  # Nm
const FRONT_BRAKE_RATIO = 0.3  # Front brake is 30% of rear

# Tire Physics
const TIRE_FRICTION_FORWARD = 1.5  # Forward/backward grip
const TIRE_FRICTION_LATERAL = 1.2  # Side-to-side grip
const TIRE_ROLLING_RESISTANCE = 0.015  # Rolling friction

# Rider Weight Transfer
const LEAN_TORQUE_MULTIPLIER = 200.0  # Nm per unit lean
const WEIGHT_SHIFT_FORCE = 800.0  # N
const MAX_LEAN_ANGLE = 30.0  # degrees
const LEAN_SPEED = 3.0  # How fast rider can shift weight

# Air Resistance
const AIR_DRAG_COEFFICIENT = 0.3
const FRONTAL_AREA = 0.7  # m² (rider + bike)

# Stability Helpers (optional, for easier gameplay)
const GYROSCOPIC_STABILITY = 0.1  # 0.0 = none, 1.0 = unrealistic auto-balance
const ANGULAR_DAMPING = 0.1  # Reduces unwanted rotation

# Crash Detection
const CRASH_ANGULAR_VELOCITY_THRESHOLD = 8.0  # rad/s
const CRASH_IMPACT_THRESHOLD = 15.0  # m/s collision speed
