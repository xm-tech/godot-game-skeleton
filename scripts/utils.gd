class_name Utils
extends RefCounted
## 项目内共享的通用小工具（不绑定任何场景）。


## 返回一个随机布尔值，[param probability] 为 true 的概率（取值 [0.0, 1.0]）。
static func chance(probability: float) -> bool:
	return randf() < probability


## 从 [param array] 随机取一个元素，数组为空时返回 null。
static func pick_random(array: Array) -> Variant:
	if array.is_empty():
		return null
	return array[randi() % array.size()]


## 把秒数转成 "MM:SS" 字符串（例如 125.0 -> "02:05"）。
static func format_time(seconds: float) -> String:
	var total := maxi(int(seconds), 0)
	return "%02d:%02d" % [total / 60, total % 60]
