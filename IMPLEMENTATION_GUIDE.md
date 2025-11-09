# Dirt Bike Trials Game - Complete Implementation Guide

## Project Overview

A 3D dirt bike trials game inspired by Trials Evolution with a Draw Rider-style level editor. Built in Godot 4.5 for Steam (PC with keyboard/mouse/Xbox controller) with mobile (iOS/Android) support.

### Core Features
- Realistic bike physics with rider weight transfer
- 3D drawing-based level editor with automatic collision generation
- Cross-platform input support (keyboard, mouse, Xbox controller, touch)
- Ragdoll physics for crashes
- Procedural rider animations
- Level sharing system

---

## Quick Start Guide

### Current Project Status

**✅ Completed:**
- Project structure and folder organization
- All autoload singletons (GameManager, InputManager, LevelManager, SettingsManager)
- Core physics scripts (physics constants, spring-damper)
- Utility classes (curve, mesh, math utilities)
- Data structures (LevelData, BikeStats, UserProfile)
- Input system configuration (keyboard, gamepad, touch)
- Main scene with test ground
- Jolt Physics configuration

**🔨 Next Steps (Phase 1 - Bike Physics):**
1. Create bike scene structure
2. Implement wheel physics
3. Implement suspension system
4. Create bike controller
5. Test on the included test ground

### Running the Project

1. Open Godot 4.5 (or later)
2. Import project by selecting `project.godot`
3. Press F5 to run (you'll see an empty test scene with a ground plane)

**Note:** Jolt Physics is configured in `project.godot`. If Godot 4.4+ is installed, it's built-in. For earlier versions, you may need to install the Jolt Physics addon.

### Key Files Overview

**Autoloads (Always accessible via their name):**
- `GameManager` - Game state, level flow, scoring
- `InputManager` - Cross-platform input (call `InputManager.get_throttle()`, etc.)
- `LevelManager` - Level loading/saving
- `SettingsManager` - User preferences

**Utilities:**
- `scripts/physics/physics_constants.gd` - Tweak all physics values here
- `scripts/physics/spring_damper.gd` - Spring-damper calculations
- `scripts/utils/curve_utils.gd` - Bezier curves, smoothing
- `scripts/utils/mesh_utils.gd` - Runtime mesh generation
- `scripts/utils/math_utils.gd` - Math helpers

**Data Classes:**
- `scripts/data/level_data.gd` - Level save/load format
- `scripts/data/bike_stats.gd` - Bike configurations
- `scripts/data/user_profile.gd` - Player progress

### Quick Test Checklist

Before starting Phase 1, verify:
- [ ] Project opens without errors in Godot 4.5
- [ ] Main scene runs (F5) - you should see a test ground
- [ ] No errors in Output console
- [ ] All autoload scripts are registered (check Project Settings → Autoload)

---

## Technology Stack

### Engine & Physics
- **Engine**: Godot 4.5
- **Physics Engine**: Jolt Physics (better performance than default Godot Physics)
  - Enable in: `Project Settings → Physics → 3D → Physics Engine → Jolt Physics`
  - Required for: Better vehicle simulation, improved stability, mobile performance
- **Rendering**: Forward+ (PC/Console), Mobile (iOS/Android)

### Key Godot Systems Used
- `RigidBody3D` - Bike body and wheels
- `Generic6DOFJoint3D` - Suspension and rider joints
- `Path3D` + `CSGPolygon3D` - Track mesh generation from drawn paths
- `PhysicalBone3D` - Ragdoll system for rider
- `Skeleton3D` + IK - Rider animations
- `InputMap` - Cross-platform input abstraction

---

## Project Architecture

```
TrialsGame/
├── scenes/
│   ├── main/
│   │   ├── main.tscn                    # Main game scene
│   │   └── main.gd                      # Game state management
│   ├── bike/
│   │   ├── bike.tscn                    # Complete bike assembly
│   │   ├── bike_controller.gd           # Input handling & control
│   │   ├── bike_physics.gd              # Physics calculations
│   │   ├── suspension.tscn              # Suspension component
│   │   ├── suspension.gd                # Spring-damper physics
│   │   ├── wheel.tscn                   # Individual wheel
│   │   └── wheel.gd                     # Wheel physics & rotation
│   ├── rider/
│   │   ├── rider.tscn                   # Rider skeleton & mesh
│   │   ├── rider_controller.gd          # Lean/weight transfer
│   │   ├── rider_animator.gd            # Procedural IK animation
│   │   ├── rider_ragdoll.gd             # Crash ragdoll system
│   │   └── rider_ik.tscn                # IK setup for procedural anim
│   ├── level_editor/
│   │   ├── editor.tscn                  # Editor UI & viewport
│   │   ├── editor_controller.gd         # Main editor logic
│   │   ├── drawing_canvas.tscn          # 3D drawing canvas
│   │   ├── drawing_input.gd             # Mouse/touch input capture
│   │   ├── path_generator.gd            # Convert input to Path3D
│   │   ├── track_generator.gd           # Generate mesh from path
│   │   ├── collision_generator.gd       # Create collision shapes
│   │   ├── track_smoother.gd            # Bezier curve smoothing
│   │   └── object_placer.tscn           # Place obstacles/decorations
│   ├── track/
│   │   ├── track.tscn                   # Track container
│   │   ├── track_segment.gd             # Individual track piece
│   │   ├── checkpoint.tscn              # Start/finish/checkpoint
│   │   └── obstacle.tscn                # Track obstacles
│   ├── camera/
│   │   ├── game_camera.tscn             # 2.5D follow camera
│   │   ├── camera_controller.gd         # Smooth follow logic
│   │   └── editor_camera.tscn           # Free camera for editor
│   ├── ui/
│   │   ├── hud.tscn                     # In-game HUD
│   │   ├── main_menu.tscn               # Main menu
│   │   ├── level_browser.tscn           # Browse custom levels
│   │   ├── mobile_controls.tscn         # Touch controls overlay
│   │   └── settings.tscn                # Settings menu
│   └── fx/
│       ├── particle_dirt.tscn           # Dirt particles
│       ├── particle_smoke.tscn          # Exhaust smoke
│       └── sound_controller.gd          # Dynamic engine sounds
├── scripts/
│   ├── autoload/
│   │   ├── game_manager.gd              # Singleton: Game state
│   │   ├── input_manager.gd             # Singleton: Input abstraction
│   │   ├── level_manager.gd             # Singleton: Level loading/saving
│   │   └── settings_manager.gd          # Singleton: User settings
│   ├── physics/
│   │   ├── spring_damper.gd             # Spring-damper calculations
│   │   ├── wheel_physics_helper.gd      # Wheel force calculations
│   │   └── physics_constants.gd         # Physics tuning values
│   ├── utils/
│   │   ├── curve_utils.gd               # Bezier & spline utilities
│   │   ├── mesh_utils.gd                # Runtime mesh generation
│   │   └── math_utils.gd                # Vector/angle helpers
│   └── data/
│       ├── level_data.gd                # Level save/load format
│       ├── bike_stats.gd                # Bike configuration data
│       └── user_profile.gd              # Player progress/settings
├── assets/
│   ├── models/
│   │   ├── bike/                        # Bike 3D models
│   │   ├── rider/                       # Rider 3D model & skeleton
│   │   └── obstacles/                   # Track obstacles
│   ├── textures/
│   ├── audio/
│   │   ├── engine/                      # Engine sounds
│   │   ├── impacts/                     # Crash sounds
│   │   └── music/                       # Background music
│   └── ui/
│       ├── icons/                       # UI icons
│       └── fonts/                       # UI fonts
├── levels/
│   ├── default/                         # Built-in levels
│   └── custom/                          # User-created levels
└── addons/
    └── jolt_physics/                    # Jolt physics addon (if needed)
```

---

## Scene Structure Details

### 1. Bike Scene (`scenes/bike/bike.tscn`)

```
Bike (RigidBody3D) [bike_controller.gd, bike_physics.gd]
├── BikeBody (MeshInstance3D)
│   └── CollisionShape3D (ConvexPolygon)
├── FrontSuspension (Node3D) [suspension.gd]
│   ├── SuspensionArm (Generic6DOFJoint3D)
│   └── FrontWheel (RigidBody3D) [wheel.gd]
│       ├── WheelMesh (MeshInstance3D)
│       └── WheelCollision (CollisionShape3D - Cylinder)
├── RearSuspension (Node3D) [suspension.gd]
│   ├── SuspensionArm (Generic6DOFJoint3D)
│   └── RearWheel (RigidBody3D) [wheel.gd]
│       ├── WheelMesh (MeshInstance3D)
│       ├── WheelCollision (CollisionShape3D - Cylinder)
│       └── DriveForcePoint (Marker3D)
├── RiderMount (Node3D)
│   └── Rider (Instance of rider.tscn)
├── EngineSound (AudioStreamPlayer3D)
└── ExhaustParticles (GPUParticles3D)
```

**Key Properties:**
- **Mass**: 150 kg (bike + rider)
- **Center of Mass**: Slightly below seat, forward of rear wheel
- **Continuous CD**: Enabled (prevent tunneling at high speeds)
- **Custom Integrator**: Enabled (for precise suspension control)

### 2. Rider Scene (`scenes/rider/rider.tscn`)

```
Rider (Node3D) [rider_controller.gd, rider_animator.gd]
├── Skeleton3D
│   ├── Head (PhysicalBone3D)
│   ├── Spine (PhysicalBone3D)
│   ├── LeftArm (PhysicalBone3D)
│   ├── RightArm (PhysicalBone3D)
│   ├── LeftLeg (PhysicalBone3D)
│   └── RightLeg (PhysicalBone3D)
├── RiderMesh (MeshInstance3D)
│   └── Skeleton: -> ../Skeleton3D
├── IKTargets (Node3D)
│   ├── LeftHandTarget (Marker3D)   # Attached to handlebar
│   ├── RightHandTarget (Marker3D)  # Attached to handlebar
│   ├── LeftFootTarget (Marker3D)   # Attached to left peg
│   └── RightFootTarget (Marker3D)  # Attached to right peg
├── IKChains
│   ├── LeftArmIK (SkeletonIK3D)
│   ├── RightArmIK (SkeletonIK3D)
│   ├── LeftLegIK (SkeletonIK3D)
│   └── RightLegIK (SkeletonIK3D)
└── RagdollController (Node) [rider_ragdoll.gd]
```

**Animation States:**
- **Normal**: IK-based procedural animation, bones follow bike
- **Leaning**: Spine rotation based on input, weight shifts
- **Crash**: PhysicalBone3D simulation activated (ragdoll)

### 3. Level Editor Scene (`scenes/level_editor/editor.tscn`)

```
LevelEditor (Control) [editor_controller.gd]
├── ViewportContainer (ViewportContainer)
│   └── Viewport3D (SubViewport)
│       ├── EditorCamera (Camera3D) [editor_camera.gd]
│       ├── DirectionalLight3D
│       ├── DrawingCanvas (Node3D) [drawing_input.gd]
│       │   ├── CurrentPath (Path3D)
│       │   │   └── PathFollow3D
│       │   │       └── DrawCursor (MeshInstance3D)
│       │   └── PathVisualizer (MeshInstance3D)
│       └── TrackPreview (StaticBody3D)
│           ├── GeneratedMesh (MeshInstance3D)
│           └── GeneratedCollision (CollisionShape3D)
├── Toolbar (HBoxContainer)
│   ├── DrawButton (Button)
│   ├── EraseButton (Button)
│   ├── SmoothButton (Button)
│   ├── ObjectPlaceButton (Button)
│   ├── TestButton (Button)
│   └── SaveButton (Button)
├── PropertiesPanel (PanelContainer)
│   ├── TrackWidthSlider (HSlider)
│   ├── TrackMaterialOption (OptionButton)
│   ├── SmoothingSlider (HSlider)
│   └── GravitySlider (HSlider)
└── ObjectPalette (ItemList)
```

**Editor Workflow:**
1. User draws with mouse/touch → captured by `drawing_input.gd`
2. Points added to `Path3D.curve`
3. `track_smoother.gd` applies Bezier smoothing
4. `track_generator.gd` creates `CSGPolygon3D` along path
5. `collision_generator.gd` generates trimesh collision
6. User can test by pressing play (spawns bike at start)

### 4. Game Camera (`scenes/camera/game_camera.tscn`)

```
GameCamera (Camera3D) [camera_controller.gd]
├── CameraArm (SpringArm3D)
└── LookAtTarget (Marker3D)
```

**Camera Setup (2.5D Side-Scroller):**
- **Projection**: Orthographic (for consistent scale)
- **Size**: 20 units
- **Position**: (0, 5, 15) relative to bike
- **Rotation**: (-15°, 0, 0) - slight downward angle
- **Follow Mode**: Smooth lerp to bike position
- **Alternative**: Perspective with fixed side angle for more depth

### 5. Track Scene (`scenes/track/track.tscn`)

```
Track (Node3D)
├── TrackMesh (StaticBody3D)
│   ├── MeshInstance3D (Generated at runtime)
│   └── CollisionShape3D (ConcavePolygonShape3D)
├── StartPoint (Marker3D)
├── FinishLine (Area3D)
│   └── CollisionShape3D
├── Checkpoints (Node3D)
│   ├── Checkpoint1 (Area3D)
│   ├── Checkpoint2 (Area3D)
│   └── ...
├── Decorations (Node3D)
│   ├── Rock1 (MeshInstance3D)
│   ├── Tree1 (MeshInstance3D)
│   └── ...
└── Obstacles (Node3D)
    ├── Ramp1 (StaticBody3D)
    └── ...
```

---

## Physics System Design

### Bike Physics Components

#### 1. **Spring-Damper Suspension** (`suspension.gd`)

```gdscript
# Springs connect wheels to bike body
class_name Suspension extends Node3D

# Physics constants
const SPRING_RATE = 15000.0  # N/m - stiffer for trials bike
const DAMPER_RATE = 750.0    # SPRING_RATE / 20
const SUSPENSION_TRAVEL = 0.25  # meters
const REST_LENGTH = 0.3     # meters

var current_compression: float = 0.0
var compression_velocity: float = 0.0

func calculate_suspension_force(wheel_body: RigidBody3D, bike_body: RigidBody3D) -> Vector3:
    # Calculate compression
    var current_length = wheel_body.global_position.distance_to(global_position)
    current_compression = REST_LENGTH - current_length
    current_compression = clamp(current_compression, 0.0, SUSPENSION_TRAVEL)

    # Spring force: F = -k * x
    var spring_force = SPRING_RATE * current_compression

    # Damper force: F = -c * v
    var damper_force = DAMPER_RATE * compression_velocity

    # Total force in upward direction
    var direction = (bike_body.global_position - wheel_body.global_position).normalized()
    return direction * (spring_force + damper_force)
```

**Connection to Bike:**
- Attached to `bike.gd` via `_integrate_forces()`
- Force applied to wheel `RigidBody3D` each physics frame
- Bike body receives equal and opposite force

#### 2. **Wheel Physics** (`wheel.gd`)

```gdscript
class_name Wheel extends RigidBody3D

# Wheel properties
const WHEEL_RADIUS = 0.35  # meters
const WHEEL_MASS = 5.0     # kg
const TIRE_FRICTION = 1.5  # Grip multiplier
const MAX_BRAKE_TORQUE = 500.0  # Nm
const MAX_ENGINE_TORQUE = 300.0  # Nm (rear wheel only)

var is_grounded: bool = false
var ground_normal: Vector3 = Vector3.UP
var angular_velocity: float = 0.0

# Connected via bike_physics.gd
var drive_torque: float = 0.0
var brake_torque: float = 0.0

func _physics_process(delta):
    check_ground_contact()
    apply_drive_forces()
    calculate_rotation()

func check_ground_contact():
    # Raycast downward from wheel center
    var space_state = get_world_3d().direct_space_state
    var query = PhysicsRayQueryParameters3D.create(
        global_position,
        global_position + Vector3.DOWN * (WHEEL_RADIUS + 0.1)
    )
    var result = space_state.intersect_ray(query)

    is_grounded = result.size() > 0
    if is_grounded:
        ground_normal = result.normal

func apply_drive_forces():
    if not is_grounded:
        return

    # Forward force from engine/braking
    var net_torque = drive_torque - brake_torque
    var forward_force = net_torque / WHEEL_RADIUS

    # Apply friction based on ground contact
    var forward_dir = -global_transform.basis.z
    var friction_force = forward_force * TIRE_FRICTION

    apply_central_force(forward_dir * friction_force)

    # Lateral friction (prevents sliding sideways)
    var lateral_velocity = linear_velocity.dot(global_transform.basis.x)
    var lateral_friction = -lateral_velocity * TIRE_FRICTION * 100.0
    apply_central_force(global_transform.basis.x * lateral_friction)
```

**Connection to Bike:**
- `bike_physics.gd` sets `drive_torque` and `brake_torque`
- Suspension script applies forces to wheel
- Wheel rotation calculated from `angular_velocity`

#### 3. **Bike Controller** (`bike_controller.gd`)

```gdscript
class_name BikeController extends Node

# Input values (set by input_manager.gd)
var throttle: float = 0.0       # 0.0 to 1.0
var brake: float = 0.0          # 0.0 to 1.0
var lean: float = 0.0           # -1.0 to 1.0 (back to forward)

# References (set in _ready)
@onready var bike_body: RigidBody3D = get_parent()
@onready var front_wheel: Wheel = $"../FrontSuspension/FrontWheel"
@onready var rear_wheel: Wheel = $"../RearSuspension/RearWheel"
@onready var rider: Node3D = $"../RiderMount/Rider"

func _process(delta):
    # Get input from InputManager singleton
    throttle = InputManager.get_throttle()
    brake = InputManager.get_brake()
    lean = InputManager.get_lean()

    # Update rider lean
    rider.set_lean(lean)

func _physics_process(delta):
    # Apply torques to wheels
    rear_wheel.drive_torque = throttle * Wheel.MAX_ENGINE_TORQUE
    rear_wheel.brake_torque = brake * Wheel.MAX_BRAKE_TORQUE
    front_wheel.brake_torque = brake * Wheel.MAX_BRAKE_TORQUE * 0.3

    # Apply lean torque to bike body
    apply_lean_torque()

func apply_lean_torque():
    # Rider weight shift creates torque
    var lean_torque = lean * 200.0  # Nm
    bike_body.apply_torque(Vector3(0, 0, lean_torque))
```

**Input Flow:**
1. `InputManager` (autoload) reads keyboard/gamepad/touch
2. `bike_controller.gd` gets values from `InputManager`
3. Values applied to bike physics
4. Rider animation updated to match

#### 4. **Rider Weight Transfer** (`rider_controller.gd`)

```gdscript
class_name RiderController extends Node3D

# References
@onready var skeleton: Skeleton3D = $Skeleton3D
@onready var spine_bone_id = skeleton.find_bone("Spine")
@onready var bike: RigidBody3D = get_parent().get_parent()

# Lean parameters
var current_lean: float = 0.0
var target_lean: float = 0.0
const LEAN_SPEED = 3.0
const MAX_LEAN_ANGLE = 30.0  # degrees

# Weight shift effect on bike
const WEIGHT_SHIFT_FORCE = 800.0  # Newtons

func set_lean(lean_input: float):
    target_lean = lean_input

func _physics_process(delta):
    # Smoothly interpolate lean
    current_lean = lerp(current_lean, target_lean, LEAN_SPEED * delta)

    # Rotate spine bone
    var lean_angle = current_lean * deg_to_rad(MAX_LEAN_ANGLE)
    var spine_transform = skeleton.get_bone_pose(spine_bone_id)
    spine_transform.basis = Basis(Vector3.FORWARD, lean_angle)
    skeleton.set_bone_pose(spine_bone_id, spine_transform)

    # Apply weight shift force to bike
    var weight_offset = Vector3(current_lean * 0.3, 0, 0)  # Offset from center
    var force_direction = Vector3.DOWN * WEIGHT_SHIFT_FORCE * current_lean
    bike.apply_force(force_direction, weight_offset)

func trigger_ragdoll():
    # Activate PhysicalBone simulation
    $Skeleton3D.physical_bones_start_simulation()
    # Disable IK
    $IKChains.get_children().all(func(ik): ik.start())
```

**Connection Points:**
- Called by `bike_controller.gd`
- Affects bike physics via `apply_force()`
- IK targets positioned on bike (handlebars, foot pegs)

---

## Level Editor System

### Drawing to Track Pipeline

```
User Input → Path3D → Smoothing → Mesh Generation → Collision
```

#### 1. **Drawing Input** (`drawing_input.gd`)

```gdscript
class_name DrawingInput extends Node3D

signal path_updated(path: Path3D)

@export var min_point_distance: float = 0.5  # Minimum distance between points
@export var draw_plane_y: float = 0.0        # Y level for drawing

var is_drawing: bool = false
var current_path: Path3D = null
var last_point: Vector3 = Vector3.ZERO
var camera: Camera3D

func _ready():
    camera = get_viewport().get_camera_3d()

func _input(event):
    # Mouse/touch drawing
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT:
            if event.pressed:
                start_drawing()
            else:
                finish_drawing()

    elif event is InputEventMouseMotion and is_drawing:
        add_point_from_screen(event.position)

    # Touch support
    elif event is InputEventScreenTouch:
        if event.pressed:
            start_drawing()
        else:
            finish_drawing()

    elif event is InputEventScreenDrag and is_drawing:
        add_point_from_screen(event.position)

func start_drawing():
    is_drawing = true
    current_path = Path3D.new()
    current_path.curve = Curve3D.new()
    add_child(current_path)

func add_point_from_screen(screen_pos: Vector2):
    # Project screen position to 3D drawing plane
    var from = camera.project_ray_origin(screen_pos)
    var to = from + camera.project_ray_normal(screen_pos) * 1000.0

    # Intersect with XZ plane at draw_plane_y
    var plane = Plane(Vector3.UP, draw_plane_y)
    var intersection = plane.intersects_ray(from, to - from)

    if intersection and intersection.distance_to(last_point) > min_point_distance:
        current_path.curve.add_point(intersection)
        last_point = intersection

func finish_drawing():
    is_drawing = false
    if current_path and current_path.curve.point_count > 1:
        path_updated.emit(current_path)
```

**Connection:**
- Emits signal to `editor_controller.gd`
- `editor_controller` passes path to smoothing and generation

#### 2. **Path Smoothing** (`track_smoother.gd`)

```gdscript
class_name TrackSmoother extends Node

@export var smoothing_strength: float = 0.5

func smooth_path(path: Path3D) -> Path3D:
    var original_curve = path.curve
    var smoothed_curve = Curve3D.new()

    # Apply Catmull-Rom spline smoothing
    for i in range(original_curve.point_count):
        var point = original_curve.get_point_position(i)
        smoothed_curve.add_point(point)

        # Calculate in/out tangents for smooth curves
        if i > 0 and i < original_curve.point_count - 1:
            var prev = original_curve.get_point_position(i - 1)
            var next = original_curve.get_point_position(i + 1)
            var tangent = (next - prev) * 0.5 * smoothing_strength

            smoothed_curve.set_point_in(i, -tangent)
            smoothed_curve.set_point_out(i, tangent)

    var smoothed_path = Path3D.new()
    smoothed_path.curve = smoothed_curve
    return smoothed_path
```

#### 3. **Track Generation** (`track_generator.gd`)

```gdscript
class_name TrackGenerator extends Node

@export var track_width: float = 3.0
@export var track_material: StandardMaterial3D

func generate_track_mesh(path: Path3D) -> MeshInstance3D:
    # Method 1: Using CSGPolygon3D (simpler, less control)
    var csg = CSGPolygon3D.new()
    csg.mode = CSGPolygon3D.MODE_PATH
    csg.path_node = path.get_path()

    # Create track cross-section (simple rectangle)
    var polygon = PackedVector2Array([
        Vector2(-track_width/2, -0.2),
        Vector2(-track_width/2, 0.0),
        Vector2(track_width/2, 0.0),
        Vector2(track_width/2, -0.2)
    ])
    csg.polygon = polygon
    csg.material = track_material

    # Convert to MeshInstance for performance
    var mesh_instance = MeshInstance3D.new()
    mesh_instance.mesh = csg.get_meshes()[1]  # Get generated mesh
    mesh_instance.material_override = track_material

    return mesh_instance

func generate_track_mesh_manual(path: Path3D) -> MeshInstance3D:
    # Method 2: Manual mesh generation (more control)
    var curve = path.curve
    var arrays = []
    arrays.resize(Mesh.ARRAY_MAX)

    var vertices = PackedVector3Array()
    var indices = PackedInt32Array()
    var normals = PackedVector3Array()
    var uvs = PackedVector2Array()

    var segments = 100  # Number of segments along path
    var half_width = track_width / 2.0

    for i in range(segments + 1):
        var t = float(i) / segments
        var point = curve.sample_baked(t * curve.get_baked_length())
        var forward = curve.sample_baked_tangent(t * curve.get_baked_length())
        var right = forward.cross(Vector3.UP).normalized()

        # Create two vertices (left and right edges)
        vertices.append(point - right * half_width)
        vertices.append(point + right * half_width)

        # Normals point up
        normals.append(Vector3.UP)
        normals.append(Vector3.UP)

        # UVs
        uvs.append(Vector2(0, t))
        uvs.append(Vector2(1, t))

        # Create quad indices (two triangles)
        if i < segments:
            var base = i * 2
            # Triangle 1
            indices.append(base)
            indices.append(base + 2)
            indices.append(base + 1)
            # Triangle 2
            indices.append(base + 1)
            indices.append(base + 2)
            indices.append(base + 3)

    arrays[Mesh.ARRAY_VERTEX] = vertices
    arrays[Mesh.ARRAY_INDEX] = indices
    arrays[Mesh.ARRAY_NORMAL] = normals
    arrays[Mesh.ARRAY_TEX_UV] = uvs

    var array_mesh = ArrayMesh.new()
    array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)

    var mesh_instance = MeshInstance3D.new()
    mesh_instance.mesh = array_mesh
    mesh_instance.material_override = track_material

    return mesh_instance
```

#### 4. **Collision Generation** (`collision_generator.gd`)

```gdscript
class_name CollisionGenerator extends Node

func generate_collision(mesh_instance: MeshInstance3D) -> CollisionShape3D:
    # Create trimesh collision from mesh
    var mesh = mesh_instance.mesh
    var shape = mesh.create_trimesh_shape()

    var collision_shape = CollisionShape3D.new()
    collision_shape.shape = shape

    return collision_shape

func generate_simplified_collision(path: Path3D, width: float) -> Array[CollisionShape3D]:
    # Alternative: Create segment-based collision (better performance)
    var collision_shapes = []
    var curve = path.curve
    var segments = 50

    for i in range(segments):
        var t1 = float(i) / segments
        var t2 = float(i + 1) / segments

        var p1 = curve.sample_baked(t1 * curve.get_baked_length())
        var p2 = curve.sample_baked(t2 * curve.get_baked_length())

        # Create box segment
        var segment_center = (p1 + p2) / 2.0
        var segment_length = p1.distance_to(p2)
        var direction = (p2 - p1).normalized()

        var box = BoxShape3D.new()
        box.size = Vector3(width, 0.5, segment_length)

        var collision = CollisionShape3D.new()
        collision.shape = box
        collision.global_position = segment_center
        collision.look_at(p2, Vector3.UP)

        collision_shapes.append(collision)

    return collision_shapes
```

**Editor Controller Integration** (`editor_controller.gd`):

```gdscript
func _on_path_updated(path: Path3D):
    # Clear previous track
    clear_current_track()

    # Smooth the path
    var smoothed_path = track_smoother.smooth_path(path)

    # Generate mesh
    var track_mesh = track_generator.generate_track_mesh(smoothed_path)

    # Generate collision
    var collision = collision_generator.generate_collision(track_mesh)

    # Add to scene
    var track_body = StaticBody3D.new()
    track_body.add_child(track_mesh)
    track_body.add_child(collision)
    $ViewportContainer/Viewport3D.add_child(track_body)

    current_track = track_body
```

---

## Input System Design

### Cross-Platform Input Manager (`scripts/autoload/input_manager.gd`)

```gdscript
extends Node

# Input scheme detection
enum InputScheme { KEYBOARD_MOUSE, GAMEPAD, TOUCH }
var current_scheme: InputScheme = InputScheme.KEYBOARD_MOUSE

# Input values
var throttle: float = 0.0
var brake: float = 0.0
var lean: float = 0.0
var reset_pressed: bool = false

# Touch controls reference
var touch_controls: Control = null

func _ready():
    # Auto-detect platform
    if OS.has_feature("mobile"):
        current_scheme = InputScheme.TOUCH

    # Listen for input device changes
    Input.joy_connection_changed.connect(_on_joy_connection_changed)

func _process(delta):
    match current_scheme:
        InputScheme.KEYBOARD_MOUSE:
            update_keyboard_input()
        InputScheme.GAMEPAD:
            update_gamepad_input()
        InputScheme.TOUCH:
            update_touch_input()

func update_keyboard_input():
    # Throttle: W or Up Arrow or Space
    throttle = 0.0
    if Input.is_action_pressed("throttle"):
        throttle = 1.0

    # Brake: S or Down Arrow
    brake = 0.0
    if Input.is_action_pressed("brake"):
        brake = 1.0

    # Lean: A/D or Left/Right arrows
    lean = Input.get_axis("lean_back", "lean_forward")

    # Reset: R
    reset_pressed = Input.is_action_just_pressed("reset")

func update_gamepad_input():
    # Right trigger: Throttle
    throttle = Input.get_action_strength("gamepad_throttle")

    # Left trigger: Brake
    brake = Input.get_action_strength("gamepad_brake")

    # Left stick horizontal: Lean
    lean = Input.get_axis("gamepad_lean_back", "gamepad_lean_forward")

    # B button: Reset
    reset_pressed = Input.is_action_just_pressed("gamepad_reset")

func update_touch_input():
    # Updated by mobile_controls.tscn touch buttons
    pass

func set_touch_throttle(value: float):
    throttle = value

func set_touch_brake(value: float):
    brake = value

func set_touch_lean(value: float):
    lean = value

# Getters for bike controller
func get_throttle() -> float:
    return throttle

func get_brake() -> float:
    return brake

func get_lean() -> float:
    return lean

func _on_joy_connection_changed(device: int, connected: bool):
    if connected:
        current_scheme = InputScheme.GAMEPAD
    else:
        if not OS.has_feature("mobile"):
            current_scheme = InputScheme.KEYBOARD_MOUSE
```

### Input Map Configuration (`project.godot`)

```ini
[input]

# Keyboard/Mouse
throttle={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":0,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":87,"physical_keycode":0,"unicode":0,"echo":false,"script":null)
, Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":0,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":4194320,"physical_keycode":0,"unicode":0,"echo":false,"script":null)
]
}

brake={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":0,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":83,"physical_keycode":0,"unicode":0,"echo":false,"script":null)
, Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":0,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":4194322,"physical_keycode":0,"unicode":0,"echo":false,"script":null)
]
}

lean_back={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":0,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":65,"physical_keycode":0,"unicode":0,"echo":false,"script":null)
, Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":0,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":4194319,"physical_keycode":0,"unicode":0,"echo":false,"script":null)
]
}

lean_forward={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":0,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":68,"physical_keycode":0,"unicode":0,"echo":false,"script":null)
, Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":0,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":4194321,"physical_keycode":0,"unicode":0,"echo":false,"script":null)
]
}

# Gamepad (Xbox controller)
gamepad_throttle={
"deadzone": 0.1,
"events": [Object(InputEventJoypadMotion,"resource_local_to_scene":false,"resource_name":"","device":-1,"axis":5,"axis_value":1.0,"script":null)
]
}

gamepad_brake={
"deadzone": 0.1,
"events": [Object(InputEventJoypadMotion,"resource_local_to_scene":false,"resource_name":"","device":-1,"axis":4,"axis_value":1.0,"script":null)
]
}

gamepad_lean_back={
"deadzone": 0.2,
"events": [Object(InputEventJoypadMotion,"resource_local_to_scene":false,"resource_name":"","device":-1,"axis":0,"axis_value":-1.0,"script":null)
]
}

gamepad_lean_forward={
"deadzone": 0.2,
"events": [Object(InputEventJoypadMotion,"resource_local_to_scene":false,"resource_name":"","device":-1,"axis":0,"axis_value":1.0,"script":null)
]
}

gamepad_reset={
"deadzone": 0.5,
"events": [Object(InputEventJoypadButton,"resource_local_to_scene":false,"resource_name":"","device":-1,"button_index":1,"pressure":0.0,"pressed":false,"script":null)
]
}

reset={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":0,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":82,"physical_keycode":0,"unicode":0,"echo":false,"script":null)
]
}
```

### Mobile Touch Controls (`scenes/ui/mobile_controls.tscn`)

```
MobileControls (CanvasLayer)
├── ThrottleButton (TouchScreenButton)
│   └── Icon (Sprite2D)
├── BrakeButton (TouchScreenButton)
│   └── Icon (Sprite2D)
└── LeanJoystick (Control) [virtual_joystick.gd]
    ├── Base (Sprite2D)
    └── Stick (Sprite2D)
```

**Virtual Joystick Script** (`virtual_joystick.gd`):
```gdscript
extends Control

signal lean_changed(value: float)

var is_pressed: bool = false
var center: Vector2
var current_pos: Vector2

func _ready():
    center = $Base.position

func _gui_input(event):
    if event is InputEventScreenTouch:
        if event.pressed:
            is_pressed = true
        else:
            is_pressed = false
            reset_stick()

    elif event is InputEventScreenDrag and is_pressed:
        current_pos = event.position
        update_stick()

func update_stick():
    var offset = current_pos - center
    var distance = offset.length()
    var max_distance = 50.0

    if distance > max_distance:
        offset = offset.normalized() * max_distance

    $Stick.position = center + offset

    # Emit lean value (-1 to 1)
    var lean = offset.x / max_distance
    InputManager.set_touch_lean(lean)

func reset_stick():
    $Stick.position = center
    InputManager.set_touch_lean(0.0)
```

---

## Camera System

### 2.5D Side-Scroller Camera (`camera_controller.gd`)

```gdscript
extends Camera3D

@export var follow_target: Node3D  # The bike
@export var follow_smoothness: float = 5.0
@export var offset: Vector3 = Vector3(0, 5, 15)
@export var look_ahead: float = 3.0  # Look ahead based on velocity

# Camera modes
enum CameraMode { ORTHOGRAPHIC, PERSPECTIVE }
@export var mode: CameraMode = CameraMode.ORTHOGRAPHIC

var target_position: Vector3

func _ready():
    if mode == CameraMode.ORTHOGRAPHIC:
        projection = PROJECTION_ORTHOGONAL
        size = 20.0
    else:
        projection = PROJECTION_PERSPECTIVE
        fov = 70.0

    # Slight downward angle
    rotation_degrees.x = -15.0

func _physics_process(delta):
    if not follow_target:
        return

    # Calculate target position with velocity-based look-ahead
    var bike_velocity = Vector3.ZERO
    if follow_target is RigidBody3D:
        bike_velocity = follow_target.linear_velocity

    var look_ahead_offset = Vector3(bike_velocity.x * look_ahead, 0, 0)
    target_position = follow_target.global_position + offset + look_ahead_offset

    # Smooth follow
    global_position = global_position.lerp(target_position, follow_smoothness * delta)
```

---

## Mobile Optimization

### Performance Settings

**For Mobile Builds:**

```gdscript
# scripts/autoload/settings_manager.gd
func apply_mobile_optimizations():
    if OS.has_feature("mobile"):
        # Graphics
        ProjectSettings.set_setting("rendering/quality/shadows/soft_shadow_quality", 0)
        ProjectSettings.set_setting("rendering/quality/reflections/reflection_quality", 0)
        ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa", 0)

        # Physics
        ProjectSettings.set_setting("physics/3d/physics_ticks_per_second", 30)  # Reduce from 60
        ProjectSettings.set_setting("physics/3d/sleep_threshold_linear", 0.2)
        ProjectSettings.set_setting("physics/3d/sleep_threshold_angular", 0.3)

        # Use simpler collision shapes
        # Disable post-processing effects
        # Reduce particle counts
```

### Mobile-Specific Considerations

1. **Collision Shapes**: Use simplified collision (boxes/segments) instead of trimesh
2. **Physics Rate**: 30 Hz instead of 60 Hz
3. **Mesh LOD**: Reduce track segment count on mobile
4. **Texture Resolution**: Lower resolution textures for mobile
5. **Particle Effects**: Reduce max particles by 50%
6. **Audio**: Use compressed audio formats

---

## Implementation Phases

### Phase 1: Core Bike Physics (Week 1-2)

**Tasks:**
1. Set up Godot 4.5 project with Jolt Physics
2. Create bike scene with RigidBody3D + 2 wheels
3. Implement suspension system (spring-damper)
4. Implement wheel physics (torque, friction, rotation)
5. Create basic bike controller (throttle, brake)
6. Build simple test track (static geometry)
7. Tune physics parameters for Trials-like feel

**Files to Create:**
- `scenes/bike/bike.tscn`
- `scenes/bike/bike_controller.gd`
- `scenes/bike/bike_physics.gd`
- `scenes/bike/suspension.gd`
- `scenes/bike/wheel.gd`
- `scripts/physics/spring_damper.gd`
- `scripts/physics/physics_constants.gd`

**Testing:**
- Bike should drive smoothly on flat ground
- Suspension should compress/extend realistically
- Bike should handle ramps and jumps
- Physics should feel responsive

### Phase 2: Rider System (Week 2-3)

**Tasks:**
1. Import/create rider 3D model with skeleton
2. Set up rider scene with Skeleton3D
3. Implement IK system for hands/feet
4. Create rider controller with lean mechanics
5. Implement weight transfer (apply forces to bike)
6. Set up ragdoll with PhysicalBone3D
7. Create crash detection and ragdoll activation

**Files to Create:**
- `scenes/rider/rider.tscn`
- `scenes/rider/rider_controller.gd`
- `scenes/rider/rider_animator.gd`
- `scenes/rider/rider_ragdoll.gd`

**Testing:**
- Rider should lean forward/back with input
- Weight transfer should affect bike balance
- IK should keep hands on handlebars, feet on pegs
- Ragdoll should activate on crashes

### Phase 3: Input System (Week 3)

**Tasks:**
1. Create InputManager singleton
2. Set up Input Map with keyboard/gamepad/touch actions
3. Implement gamepad support with Xbox controller
4. Create mobile touch controls UI
5. Implement virtual joystick for lean
6. Add input scheme auto-detection and switching

**Files to Create:**
- `scripts/autoload/input_manager.gd`
- `scenes/ui/mobile_controls.tscn`
- `scenes/ui/virtual_joystick.gd`

**Testing:**
- Test with keyboard (WASD + arrows)
- Test with Xbox controller
- Test touch controls on mobile (or simulator)

### Phase 4: Camera System (Week 3)

**Tasks:**
1. Create game camera with 2.5D setup
2. Implement smooth follow with lerp
3. Add velocity-based look-ahead
4. Create editor camera (free movement)
5. Test orthographic vs perspective

**Files to Create:**
- `scenes/camera/game_camera.tscn`
- `scenes/camera/camera_controller.gd`
- `scenes/camera/editor_camera.tscn`

**Testing:**
- Camera should smoothly follow bike
- No jitter or sudden movements
- Look-ahead should feel natural

### Phase 5: Level Editor - Drawing (Week 4-5)

**Tasks:**
1. Create editor scene and UI
2. Implement drawing input (mouse + touch)
3. Create Path3D from input points
4. Implement path smoothing (Bezier curves)
5. Add undo/redo system
6. Create drawing visualization

**Files to Create:**
- `scenes/level_editor/editor.tscn`
- `scenes/level_editor/editor_controller.gd`
- `scenes/level_editor/drawing_input.gd`
- `scenes/level_editor/track_smoother.gd`
- `scripts/utils/curve_utils.gd`

**Testing:**
- Drawing should feel smooth and responsive
- Smoothing should create nice curves
- Works with both mouse and touch

### Phase 6: Level Editor - Track Generation (Week 5-6)

**Tasks:**
1. Implement track mesh generation from Path3D
2. Test CSGPolygon3D method
3. Implement manual mesh generation for more control
4. Create collision generation system
5. Add track materials and textures
6. Implement track width/properties adjustment

**Files to Create:**
- `scenes/level_editor/track_generator.gd`
- `scenes/level_editor/collision_generator.gd`
- `scripts/utils/mesh_utils.gd`

**Testing:**
- Generated tracks should have proper collision
- Bike should drive on drawn tracks
- Collision should be accurate

### Phase 7: Level Editor - Objects & Testing (Week 6)

**Tasks:**
1. Create object placement system
2. Add ramps, obstacles, decorations
3. Implement "test level" mode (spawn bike)
4. Add start/finish/checkpoint placement
5. Create level validation (check for gaps, impossible sections)

**Files to Create:**
- `scenes/level_editor/object_placer.gd`
- `scenes/track/obstacle.tscn`
- `scenes/track/checkpoint.tscn`

**Testing:**
- Should be able to place and move objects
- Test mode should spawn bike at start point
- Can complete a full level loop

### Phase 8: Level Save/Load (Week 7)

**Tasks:**
1. Design level data format (JSON or custom)
2. Implement level serialization
3. Implement level deserialization
4. Create level browser UI
5. Add level metadata (name, author, difficulty)

**Files to Create:**
- `scripts/data/level_data.gd`
- `scripts/autoload/level_manager.gd`
- `scenes/ui/level_browser.tscn`

**Testing:**
- Save level, close editor, reload level
- All objects, checkpoints preserved
- Track collision works after loading

### Phase 9: UI & Menus (Week 7-8)

**Tasks:**
1. Create main menu
2. Create HUD (time, speed, checkpoint counter)
3. Create pause menu
4. Create settings menu
5. Create level completion screen
6. Add sound effects and music

**Files to Create:**
- `scenes/ui/main_menu.tscn`
- `scenes/ui/hud.tscn`
- `scenes/ui/settings.tscn`
- `scenes/fx/sound_controller.gd`

**Testing:**
- All menus navigable with keyboard/gamepad/touch
- Settings persist between sessions
- HUD updates in real-time

### Phase 10: Polish & Mobile Optimization (Week 8-9)

**Tasks:**
1. Implement mobile optimization settings
2. Reduce physics rate on mobile
3. Simplify collision shapes for mobile
4. Add LOD for distant objects
5. Optimize particle effects
6. Performance profiling and optimization
7. Add visual polish (particles, trails, etc.)

**Files to Create:**
- `scripts/autoload/settings_manager.gd`

**Testing:**
- Target 60 FPS on PC, 30 FPS on mobile
- No physics glitches or tunneling
- Smooth gameplay on mid-range mobile devices

### Phase 11: Export & Deployment (Week 9-10)

**Tasks:**
1. Set up Windows export
2. Set up macOS export (if needed)
3. Set up Linux export
4. Set up Android export with proper build template
5. Set up iOS export with Xcode project
6. Test on real devices
7. Create Steam build (if targeting Steam)

**Files to Create:**
- Export presets in Godot
- Android/iOS build configurations

**Testing:**
- Test all platforms
- Verify controller support on all platforms
- Verify touch controls on mobile

---

## Code Connection Points

### Key Singleton (Autoload) Scripts

These are accessed globally throughout the project:

1. **GameManager** (`scripts/autoload/game_manager.gd`)
   - Accessed by: All scenes
   - Purpose: Game state, scene transitions, score tracking
   - Example: `GameManager.start_level(level_data)`

2. **InputManager** (`scripts/autoload/input_manager.gd`)
   - Accessed by: `bike_controller.gd`, UI scripts
   - Purpose: Cross-platform input abstraction
   - Example: `InputManager.get_throttle()`

3. **LevelManager** (`scripts/autoload/level_manager.gd`)
   - Accessed by: Editor, main menu, game scene
   - Purpose: Level loading, saving, browsing
   - Example: `LevelManager.save_level(level_data, "my_track.json")`

4. **SettingsManager** (`scripts/autoload/settings_manager.gd`)
   - Accessed by: Settings menu, platform init
   - Purpose: User preferences, graphics settings
   - Example: `SettingsManager.get_setting("master_volume")`

### Scene Instance References

**How scenes reference each other:**

```gdscript
# bike_controller.gd gets references to bike parts
@onready var front_wheel: Wheel = $"../FrontSuspension/FrontWheel"
@onready var rear_wheel: Wheel = $"../RearSuspension/RearWheel"
@onready var rider: RiderController = $"../RiderMount/Rider"

# rider_controller.gd gets reference to bike
@onready var bike: RigidBody3D = get_parent().get_parent()

# camera_controller.gd gets reference via export var
@export var follow_target: Node3D  # Set in editor to bike

# editor_controller.gd references drawing components
@onready var drawing_input: DrawingInput = $ViewportContainer/Viewport3D/DrawingCanvas
@onready var track_generator: TrackGenerator = $TrackGenerator
```

### Signal Connections

**Key signals and their connections:**

```gdscript
# Drawing system
# drawing_input.gd emits:
signal path_updated(path: Path3D)
# Connected to:
editor_controller._on_path_updated()

# Checkpoint system
# checkpoint.tscn emits:
signal checkpoint_passed(checkpoint_id: int)
# Connected to:
GameManager._on_checkpoint_passed()

# Crash detection
# bike_controller.gd emits:
signal bike_crashed()
# Connected to:
rider_controller.trigger_ragdoll()
GameManager._on_bike_crashed()

# Input scheme changes
# InputManager emits:
signal input_scheme_changed(scheme: InputScheme)
# Connected to:
UI._update_button_prompts()
```

### Data Flow Example: Drawing a Track

```
1. User draws on screen
   ↓
2. drawing_input.gd captures mouse/touch events
   ↓
3. Adds points to Path3D.curve
   ↓
4. Emits path_updated signal
   ↓
5. editor_controller.gd receives signal
   ↓
6. Calls track_smoother.smooth_path()
   ↓
7. Calls track_generator.generate_track_mesh()
   ↓
8. Calls collision_generator.generate_collision()
   ↓
9. Adds StaticBody3D with mesh + collision to scene
   ↓
10. Track is now visible and has physics collision
```

### Data Flow Example: Bike Control

```
1. User presses throttle (W key / RT trigger / touch button)
   ↓
2. InputManager detects input in _process()
   ↓
3. Updates internal throttle value
   ↓
4. bike_controller.gd calls InputManager.get_throttle()
   ↓
5. Sets rear_wheel.drive_torque
   ↓
6. wheel.gd in _physics_process() applies force
   ↓
7. suspension.gd calculates spring forces
   ↓
8. Forces applied to wheel RigidBody3D
   ↓
9. Bike accelerates forward
```

---

## Export Configuration

### Steam (Windows/macOS/Linux)

**Export Settings:**
- **Runnable**: Yes
- **Embed PCK**: Yes
- **Texture Format**: S3TC, BPTC
- **Binary Format**: 64 bits

**Steam Integration** (optional):
- Use GodotSteam plugin for achievements, leaderboards
- Workshop integration for level sharing

### Android

**Requirements:**
- Android SDK
- JDK 11+
- Android Build Template installed

**Export Settings:**
- **Min SDK**: 21 (Android 5.0)
- **Target SDK**: 33
- **Architectures**: arm64-v8a, armeabi-v7a
- **Permissions**: INTERNET (for level sharing)
- **Screen Orientation**: Landscape

**Optimize:**
- Use mobile renderer
- Enable physics optimization
- Reduce texture sizes

### iOS

**Requirements:**
- macOS with Xcode
- Apple Developer Account ($99/year)
- iOS device for testing

**Export Settings:**
- **Deployment Target**: iOS 12.0+
- **Architectures**: arm64
- **Bundle Identifier**: com.yourcompany.trialsgame
- **Privacy**: No camera/location needed

**Optimize:**
- Metal rendering
- Simplified shaders
- Compressed textures

---

## Next Steps

### Starting Development

1. **Initialize Godot Project**
   ```bash
   # Already done - project.godot exists
   # Open in Godot 4.5
   ```

2. **Enable Jolt Physics**
   - Project Settings → Physics → 3D → Physics Engine → Jolt Physics
   - Download Jolt addon if not built-in

3. **Set Up Autoloads**
   - Project Settings → Autoload
   - Add all scripts from `scripts/autoload/`

4. **Configure Input Map**
   - Project Settings → Input Map
   - Add all actions from earlier input section

5. **Start with Phase 1**
   - Create bike scene structure
   - Implement basic physics
   - Get bike driving on a test platform

### Development Tips

1. **Test Frequently**: Test physics on every change
2. **Version Control**: Commit after each phase
3. **Parameter Tuning**: Create inspector exports for all physics constants
4. **Profiler**: Use Godot profiler to find bottlenecks
5. **Mobile Testing**: Test on real devices early and often
6. **Documentation**: Comment complex physics calculations

### Common Gotchas

1. **Bike Falling Over**: 2-wheel vehicles need active balancing or assisted stability
2. **Collision Tunneling**: Use Continuous Collision Detection (CCD) for fast-moving objects
3. **Mobile Performance**: Physics is expensive - optimize early
4. **Touch Input**: Test on real device, emulator touch is different
5. **Ragdoll Jitter**: Tune PhysicalBone collision layers to prevent self-collision

---

## Questions to Consider

Before starting implementation, decide:

1. **Camera**: Orthographic (pure 2D feel) or Perspective (depth perception)?
2. **Level Sharing**: Local only or online server?
3. **Bike Models**: Single bike or multiple unlockable bikes?
4. **Multiplayer**: Local split-screen? Online leaderboards?
5. **Art Style**: Realistic or stylized?
6. **Mobile Ads**: Monetization strategy for mobile version?

---

## Resources

### Godot Documentation
- [Jolt Physics](https://docs.godotengine.org/en/latest/tutorials/physics/using_jolt_physics.html)
- [Ragdoll System](https://docs.godotengine.org/en/stable/tutorials/physics/ragdoll_system.html)
- [CSGPolygon3D](https://docs.godotengine.org/en/stable/classes/class_csgpolygon3d.html)
- [Export for Android](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html)
- [Export for iOS](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_ios.html)

### Community
- Godot Discord
- r/godot subreddit
- Godot Forums

---

## License & Credits

Add appropriate licenses for:
- Code
- Assets (models, textures, audio)
- Third-party plugins (Jolt Physics, etc.)

---

This document should be updated as development progresses. Good luck!
