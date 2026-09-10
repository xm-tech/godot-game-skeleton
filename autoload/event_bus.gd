extends Node
## 全局信号总线（Event Bus 模式）。
##
## 解耦各系统：节点之间不互相引用，而是通过这里发射 / 监听信号。
## project.godot 里的 autoload 让它成为全局可用的 `EventBus`。
##
## 用法（三步）：
##   1. 在下方加一行 signal xxx（例如 signal player_died）
##   2. 发射方：EventBus.player_died.emit()
##   3. 监听方：EventBus.player_died.connect(_on_player_died)
##
## 下面两个是通用示例信号，按需增删。

signal scene_changed(next_scene: String)
signal game_paused(paused: bool)
