extends Node2D

@onready var main_scene = $MainScene
@onready var main_menu = $MainMenu
@onready var audio_player = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_menu.hide()
	main_menu.connect("join_lobby", Callable(self, "_on_join_lobby"))
	play_song("res://doodle_lobby_song.mp3")
	
func play_song(path_to_song: String):
	var song = load(path_to_song)
	audio_player.stream = song
	audio_player.play()


func pause_song():
	audio_player.stop()
	
func _on_join_lobby():
	main_menu.hide()
	main_scene.show()
	pause_song()
	play_song("res://doodle_song.mp3")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_audio_stream_player_2d_finished() -> void:
	print('nemoguce')
	audio_player.play()
