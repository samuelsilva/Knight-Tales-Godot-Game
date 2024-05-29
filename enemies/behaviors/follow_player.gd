extends Node

@export var speed = 1.0

#@onready var sprite: AnimatedSprite2D  = $AnimatedSprite2D
var enemy: Enemy
var sprite: AnimatedSprite2D


func _ready():
	enemy = get_parent()
	sprite = enemy.get_node("AnimatedSprite2D")
	pass

# extender a física do jogo
func _physics_process(delta):
	# Calcular direção
	var player_position = GameManager.player_position #posição inicial para testes
	var difference = player_position - enemy.position
	var input_vector = difference.normalized()
	
	# Movimento
	enemy.velocity = input_vector * speed * 100.0
	enemy.move_and_slide()

	# Girar sprite
	if input_vector.x > 0:
		# desmarcar Flip H do Sprite2D
		sprite.flip_h = false
	elif input_vector.x < 0:
		# desmarcar Flip H do Sprite2D
		sprite.flip_h = true
