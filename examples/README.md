# examples —— 示例玩法（参考代码）

这个目录被 `.gdignore` 隔离，Godot **不会扫描 / 导入**它，所以不会影响你的新项目。
里面是之前做的「2D 平台战斗 demo」的完整实现，作为**参考代码**保留。

## 内容

- 玩家：状态机 + 动画 + 攻击 / 受击（`scenes/player/`）
- 敌人：AI 状态机（巡逻 / 追击 / 攻击 / 硬直）（`scenes/enemy/`）
- 战斗组件：Hitbox / Hurtbox（`scripts/components/`）
- HUD、关卡（`scenes/ui/`、`scenes/main/`）
- 数据驱动资源（`resources/`）
- 像素画 + 生成器、音效（`assets/`、`tools/`）

## 用法

- **复用某部分**（如玩家、Hitbox/Hurtbox）：把对应文件**复制**到核心对应目录即可
  （复制出来的脚本会重新参与编译，若报 `class_name` 冲突，改个类名）。
- **单独运行 demo**：把整个目录移回核心目录，并恢复 `project.godot` 里的输入映射
  和碰撞层命名。
- **不需要**：直接删除整个 `examples/` 目录。
