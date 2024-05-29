extends CanvasLayer

@onready var timer_label: Label = %TimerLabel
@onready var gold_label: Label = %GoldLabel
@onready var meat_label: Label = %MeatLabel

var time_elapsed = 0.0
var meat_counter: int = 0

func _ready():
	GameManager.player.meat_collected.connect(on_meat_collected)
	meat_label.text = str(meat_counter)

func _process(delta):
	# update timer
	time_elapsed += delta 
	var time_elapsed_in_seconds: int = floori(time_elapsed)
	var seconds: int = time_elapsed_in_seconds % 60 # usando módulo pra pegar o restante da operação de 60
	var minutes: int = time_elapsed_in_seconds / 60
	# 02:59 = 60 + 60 + 59 = 179
	# 03:00 = 60 + 60 + 60 = 180
	
	timer_label.text = "%02d:%02d" % [minutes, seconds]
	
func on_meat_collected(regeneration_value: int):
	meat_counter += 1
	meat_label.text = str(meat_counter)
