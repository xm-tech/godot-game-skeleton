# 素材（assets）

素材放这里。建议按类型分子目录：

- `audio/`　音效 / 音乐
- `sprites/`　贴图 / 精灵（或 `images/`）
- `fonts/`　字体

把素材拖进 Godot 后，用 `preload("res://assets/...")` 引用即可。

> 提示：像素风游戏记得在 Project Settings 里把
> `rendering/textures/canvas_textures/default_texture_filter` 设为 Nearest。
