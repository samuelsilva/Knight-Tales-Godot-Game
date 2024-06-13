extends Node2D

@export var gold_amount: int = 5

func _ready():
	$Area2D.body_entered.connect(on_body_entered)
	
	#detectar que entrou um corpo na área
func on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		var player: Player = body
		player.money(gold_amount)
		player.gold_collected.emit(gold_amount)
		queue_free()
