extends Node
## 以 JSON 形式在用户数据目录（user://）中保存 / 读取游戏进度。
##
## 用法：
##   SaveManager.set_value("level", 3)
##   SaveManager.save_game()
##   var level: int = SaveManager.get_value("level", 1)

const SAVE_PATH := "user://savegame.json"

var _data: Dictionary = {}


func _ready() -> void:
	load_game()


## 用 [param key] 保存单个值。
func set_value(key: String, value: Variant) -> void:
	_data[key] = value


## 读取一个值，缺失时回退到 [param default]。
func get_value(key: String, default: Variant = null) -> Variant:
	return _data.get(key, default)


func has_value(key: String) -> bool:
	return _data.has(key)


func save_game() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("SaveManager: 无法打开存档文件进行写入（错误码 %d）。" % FileAccess.get_open_error())
		return
	file.store_string(JSON.stringify(_data, "\t"))


func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		_data = {}
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_error("SaveManager: 无法打开存档文件进行读取（错误码 %d）。" % FileAccess.get_open_error())
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if parsed is Dictionary:
		_data = parsed
	else:
		push_warning("SaveManager: 存档文件不是合法的 JSON 字典，已重置为空。")
		_data = {}


func clear_save() -> void:
	_data = {}
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
