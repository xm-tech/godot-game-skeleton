extends Node
## 极简音效管理器：一个一次性 SFX 播放器池 + 一个音乐播放器。
##
## 默认在 "Master" 总线上播放。想要独立的音量滑块时，在 Audio 面板
## 新建 "SFX" 和 "Music" 两条总线，并更新下面的 `.bus` 赋值。
##
## 用法：
##   AudioManager.play_sfx(preload("res://assets/audio/sfx/jump.ogg"))
##   AudioManager.play_music(preload("res://assets/audio/music/main_theme.ogg"))

const POOL_SIZE := 8

var _sfx_players: Array[AudioStreamPlayer] = []
var _music_player: AudioStreamPlayer


func _ready() -> void:
	for i in POOL_SIZE:
		var player := AudioStreamPlayer.new()
		player.bus = "Master"
		add_child(player)
		_sfx_players.append(player)

	_music_player = AudioStreamPlayer.new()
	_music_player.bus = "Master"
	add_child(_music_player)


## 播放一次性音效，尽量复用空闲的池内播放器。
func play_sfx(stream: AudioStream, volume_db: float = 0.0, pitch: float = 1.0) -> void:
	for player in _sfx_players:
		if not player.playing:
			_start(player, stream, volume_db, pitch)
			return
	# 所有播放器都在忙：抢占最早的那个。
	_start(_sfx_players[0], stream, volume_db, pitch)


## 播放（或切换）唯一的背景音乐轨道。
func play_music(stream: AudioStream) -> void:
	if _music_player.stream == stream and _music_player.playing:
		return
	_music_player.stream = stream
	_music_player.play()


func stop_music() -> void:
	_music_player.stop()


func _start(player: AudioStreamPlayer, stream: AudioStream, volume_db: float, pitch: float) -> void:
	player.stream = stream
	player.volume_db = volume_db
	player.pitch_scale = pitch
	player.play()
