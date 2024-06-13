extends Node2D

@export var regeneration_amount: int = 10


func _ready():
	$Area2D.body_entered.connect(on_body_entered)

	
#detectar que entrou um corpo na área
func on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		var player: Player = body
		player.heal(regeneration_amount)
		player.meat_collected.emit(regeneration_amount)
		# SE FOR UMA GOLDEN MEAT
		if regeneration_amount == 100:
			GameManager.fire_counter += 1
		queue_free()
