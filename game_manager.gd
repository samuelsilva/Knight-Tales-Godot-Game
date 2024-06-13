extends Node

signal game_over

var player: Player
var player_position: Vector2
var is_game_over: bool = false

var time_elapsed = 0.0
var meat_counter: int = 0
var gold_counter: int = 0
var fire_counter: int = 0
var monsters_defeated_counter: int = 0

var time_elapsed_string: String

@onready var death_player_sound: AudioStreamPlayer2D = %SoundDeathPlayer


# Timer pra pausar o jogo
@onready var pause_timer: Timer = $PauseTimer
var is_game_paused: bool = false

func _process(delta):
	#if not pause_timer.is_stopped(): return
	# update timer
	time_elapsed += delta 
	var time_elapsed_in_seconds: int = floori(time_elapsed)
	var seconds: int = time_elapsed_in_seconds % 60 # usando módulo pra pegar o restante da operação de 60
	var minutes: int = time_elapsed_in_seconds / 60
	# 02:59 = 60 + 60 + 59 = 179
	# 03:00 = 60 + 60 + 60 = 180	
	time_elapsed_string = "%02d:%02d" % [minutes, seconds]
 

func end_game():
	if is_game_over: return
	is_game_over = true
	game_over.emit()

func reset():
	player = null
	player_position = Vector2.ZERO
	is_game_over = false
	
	time_elapsed = 0.0
	meat_counter = 0
	gold_counter= 0
	monsters_defeated_counter = 0

	for connection in game_over.get_connections():
		game_over.disconnect(connection.callable)
	

func pause_game():
	Engine.time_scale = 0.0
	is_game_paused = true
	#pause_timer.start()

func resume_game():
	Engine.time_scale = 1.0
	is_game_paused = false
	
func _on_PauseTimer_timeout():
	resume_game()
