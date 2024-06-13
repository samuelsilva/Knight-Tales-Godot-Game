extends CanvasLayer

@onready var timer_label: Label = %TimerLabel
@onready var gold_label: Label = %GoldLabel
@onready var meat_label: Label = %MeatLabel
@onready var fire_label: Label = %FireLabel


#func _ready():
#	GameManager.player.meat_collected.connect(on_meat_collected)
#	GameManager.player.gold_collected.connect(on_gold_collected)
	
func _process(delta):
	# update timer
	timer_label.text = GameManager.time_elapsed_string
	meat_label.text = str(GameManager.meat_counter)
	gold_label.text = str(GameManager.gold_counter)
	fire_label.text = str(GameManager.fire_counter)
	
