# Godot 4 Reusable Skeleton

> **English** | [简体中文](README.zh-CN.md)

A Godot 4 project skeleton following the official **Best Practices**. It ships only
**cross-game infrastructure** — no gameplay (gameplay lives in `examples/` as reference code).

> Requires Godot **4.x**. Open this folder in the editor to get started.

---

## Built-in Core

| Module | Path | Purpose |
|--------|------|---------|
| EventBus | `autoload/event_bus.gd` | Global signal bus for decoupled communication |
| SaveManager | `autoload/save_manager.gd` | JSON key-value save (reads/writes `user://`) |
| AudioManager | `autoload/audio_manager.gd` | SFX player pool + music player |
| Utils | `scripts/utils.gd` | Generic static helper functions |

---

## Project Structure

```
.
├── project.godot            # Project config (autoloads / main scene / rendering)
├── icon.svg                 # Placeholder icon (replace with yours)
├── .gitignore               # Ignores .godot/ cache
├── .editorconfig            # GDScript uses Tab indentation
│
├── autoload/                # Global singletons (registered in project.godot)
│   ├── event_bus.gd         #   Signal bus
│   ├── save_manager.gd      #   Save system
│   └── audio_manager.gd     #   SFX / music
│
├── scripts/                 # Generic scripts not tied to a scene
│   └── utils.gd             #   Helpers
│
├── scenes/                  # Scenes (one folder per scene, resources nearby)
│   └── main/                #   Entry scene (start building here)
│       ├── main.tscn
│       └── main.gd
│
├── assets/                  # Assets (audio / images / fonts)
├── resources/               # Custom Resources (data-driven)
│
└── examples/                # Sample gameplay (reference code, .gdignore-isolated, deletable)
    ├── .gdignore
    └── ...
```

---

## Start a New Game

1. Edit `project.godot`: `config/name`, `config/description`, `config/icon`.
2. Add your input map in **Project Settings → Input Map** (move / jump / attack, etc.).
3. Build your entry scene in `scenes/main/` (player, level, HUD).
4. Add `signal xxx` to `event_bus.gd` for global events.
5. Tune values with custom Resources in `resources/`.
6. Delete `examples/` (or keep it as a reference).

---

## Conventions (Team)

- **Naming**: files / variables / functions `snake_case`, classes `PascalCase`,
  constants `CONSTANT_CASE`, signals as past-tense verbs (`player_died`, `door_opened`).
  See the [GDScript style guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html).
- **Indentation**: Tab.
- **Static typing**: type variables where possible.
- **Node references**: use `@onready var x := $Node`, not `get_node("../..")` hard paths.
- **Data-driven**: put values in custom Resources (.tres); change data, not code.
- **Git**: `.godot/` is ignored; `*.uid` and `*.import` files **must be committed** (Godot 4.4+).
- **Collision layers**: name physics layers in Project Settings; agree on names, not numbers.

---

## Official Resources

- [Best Practices](https://docs.godotengine.org/en/stable/tutorials/best_practices/index.html)
- [GDScript style guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html)
- [Version control](https://docs.godotengine.org/en/stable/tutorials/best_practices/version_control_systems.html)
