extends Node2D

@export var regenerator_amount: int = 10


func _ready():
	$Area2D.body_entered.connect(on_body_entered)

	

#detectar que entrou um corpo na área
func on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		var player: Player = body
		player.heal(regenerator_amount)
		player.meat_collected.emit(regenerator_amount)
		queue_free()
