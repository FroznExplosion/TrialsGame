# TrialsGame - Dirt Bike Trials with 3D Level Editor

A 3D dirt bike trials game inspired by Trials Evolution, featuring a Draw Rider-style in-game level editor. Built in Godot 4.5 for PC (Steam) and mobile (iOS/Android).

## Features

- **Realistic Bike Physics**: Spring-based suspension, weight transfer, and Trials-like feel
- **3D Drawing Level Editor**: Draw tracks in 3D with automatic collision generation
- **Cross-Platform Input**: Keyboard, mouse, Xbox controller, and touch controls
- **Ragdoll Physics**: Dynamic crash animations
- **Procedural Rider Animations**: IK-based rider movements with weight transfer
- **Level Sharing**: Save and load custom tracks

## Technology

- **Engine**: Godot 4.5
- **Physics**: Jolt Physics (built-in to Godot 4.4+)
- **Platforms**: Windows, Linux, macOS, Android, iOS

## Project Structure

```
TrialsGame/
├── scenes/          # Game scenes (.tscn files)
├── scripts/         # GDScript files
│   ├── autoload/    # Singleton scripts
│   ├── physics/     # Physics helpers
│   ├── utils/       # Utility functions
│   └── data/        # Data structures
├── assets/          # 3D models, textures, audio
├── levels/          # Level files
│   ├── default/     # Built-in levels
│   └── custom/      # User-created levels
└── addons/          # Godot addons/plugins
```

## Getting Started

### Prerequisites

- Godot 4.5 or later
- For Android: Android SDK, JDK 11+
- For iOS: macOS with Xcode, Apple Developer Account

### Opening the Project

1. Clone this repository
2. Open Godot 4.5
3. Click "Import" and select the `project.godot` file
4. The project will open with all settings configured

### Running the Game

- Press F5 to run the project (once main scene is created)
- Use WASD or arrow keys for bike control
- A/D to lean back/forward
- R to reset

## Implementation Guide

See **[IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md)** for:
- Complete architecture documentation
- Scene structure details
- Physics system design
- Step-by-step implementation phases
- Code connection points
- Export configuration for all platforms

## Controls

### Keyboard
- **W / Up Arrow / Space**: Throttle
- **S / Down Arrow**: Brake
- **A / Left Arrow**: Lean Back
- **D / Right Arrow**: Lean Forward
- **R**: Reset bike

### Xbox Controller
- **RT (Right Trigger)**: Throttle
- **LT (Left Trigger)**: Brake
- **Left Stick Horizontal**: Lean
- **B Button**: Reset bike

### Mobile Touch
- Touch buttons for throttle and brake
- Virtual joystick for lean control

## Development Phases

1. **Phase 1**: Core bike physics (Week 1-2)
2. **Phase 2**: Rider system with weight transfer (Week 2-3)
3. **Phase 3**: Cross-platform input (Week 3)
4. **Phase 4**: Camera system (Week 3)
5. **Phase 5**: Level editor - Drawing (Week 4-5)
6. **Phase 6**: Level editor - Track generation (Week 5-6)
7. **Phase 7**: Level editor - Objects (Week 6)
8. **Phase 8**: Level save/load (Week 7)
9. **Phase 9**: UI and menus (Week 7-8)
10. **Phase 10**: Polish & optimization (Week 8-9)
11. **Phase 11**: Export & deployment (Week 9-10)

## Physics Configuration

The game uses Jolt Physics for better performance. Key settings in `project.godot`:

```ini
[physics]
3d/physics_engine="JoltPhysics3D"
3d/default_gravity=20.0
```

Tunable physics constants are in `scripts/physics/physics_constants.gd`.

## Current Status

- [x] Project structure created
- [x] Autoload singletons configured
- [x] Input system set up
- [x] Physics constants defined
- [ ] Bike physics implementation
- [ ] Rider system
- [ ] Level editor
- [ ] UI/Menus

## Contributing

This is a personal project, but feel free to fork and modify for your own use.

## License

*License TBD - Add your chosen license here*

## Credits

- Inspired by Trials Evolution (RedLynx/Ubisoft)
- Level editor concept from Draw Rider
- Built with Godot Engine

## Resources

- [Godot Documentation](https://docs.godotengine.org/)
- [Jolt Physics Documentation](https://docs.godotengine.org/en/latest/tutorials/physics/using_jolt_physics.html)
- [Implementation Guide](IMPLEMENTATION_GUIDE.md)
