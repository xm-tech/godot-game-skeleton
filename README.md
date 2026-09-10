# Godot 4 可复用骨架

一个遵循官方 **Best Practices** 的 Godot 4 项目骨架，只含**跨游戏通用的基础设施**，
不含任何玩法（玩法在 `examples/` 里作为参考代码保留）。

> 需要 Godot **4.x**。用编辑器打开本目录即可开始。

---

## 内置核心

| 模块 | 路径 | 作用 |
|------|------|------|
| EventBus | `autoload/event_bus.gd` | 全局信号总线，跨系统解耦通信 |
| SaveManager | `autoload/save_manager.gd` | JSON 键值存档（读写 `user://`） |
| AudioManager | `autoload/audio_manager.gd` | SFX 播放器池 + 音乐播放器 |
| Utils | `scripts/utils.gd` | 通用静态工具函数 |

---

## 目录结构

```
.
├── project.godot            # 工程配置（autoload / 主场景 / 渲染）
├── icon.svg                 # 占位图标（换成你的游戏图标）
├── .gitignore               # 忽略 .godot/ 缓存
├── .editorconfig            # GDScript 用 Tab 缩进
│
├── autoload/                # 全局单例（在 project.godot 注册）
│   ├── event_bus.gd         #   信号总线
│   ├── save_manager.gd      #   存档
│   └── audio_manager.gd     #   音效 / 音乐
│
├── scripts/                 # 不绑定场景的通用脚本
│   └── utils.gd             #   通用工具
│
├── scenes/                  # 场景（每个场景一个文件夹，资源就近放置）
│   └── main/                #   入口场景（从这里开始搭）
│       ├── main.tscn
│       └── main.gd
│
├── assets/                  # 素材（音频 / 图像 / 字体）
├── resources/               # 自定义 Resource（数据驱动）
│
└── examples/                # 示例玩法（参考代码，.gdignore 隔离，可直接删）
	├── .gdignore
	└── ...
```

---

## 开始一个新游戏

1. 改 `project.godot`：`config/name`、`config/description`、`config/icon`。
2. 在 **Project Settings → Input Map** 加你的输入映射（移动 / 跳跃 / 攻击等）。
3. 在 `scenes/main/` 搭你的入口场景（玩家、关卡、HUD）。
4. 需要全局事件时，在 `event_bus.gd` 加一行 `signal xxx`。
5. 数值调参用自定义 Resource，放 `resources/`。
6. 删掉 `examples/`（或用它做参考）。

---

## 约定（团队协作）

- **命名**：文件 / 变量 / 函数 `snake_case`，类名 `PascalCase`，常量 `CONSTANT_CASE`，
  信号用过去式动词（`player_died`、`door_opened`）。详见
  [GDScript 风格指南](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html)。
- **缩进**：Tab。
- **静态类型**：变量尽量带类型。
- **节点引用**：用 `@onready var x := $Node`，不写 `get_node("../..")` 硬路径。
- **数据驱动**：数值放进自定义 Resource（.tres），改数据不改代码。
- **Git**：`.godot/` 已忽略；`*.uid` 和 `*.import` 文件**必须提交**（Godot 4.4+）。
- **碰撞层**：在 Project Settings 给物理层命名，团队按层名约定，避免数字硬编码。

---

## 官方资源

- [Best Practices（最佳实践）](https://docs.godotengine.org/en/stable/tutorials/best_practices/index.html)
- [GDScript 风格指南](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html)
- [版本控制](https://docs.godotengine.org/en/stable/tutorials/best_practices/version_control_systems.html)
