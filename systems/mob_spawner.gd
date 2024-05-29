extends Node2D

#criar lista de criaturas que serão criadas
@export var creatures: Array[PackedScene]
@export var mobs_per_minute: float = 60.0

@onready var path_follow_2d : PathFollow2D = %PathFollow2D
var cooldown: float = 0.0

func _process(delta):
	# Temporizador (cooldown)
	cooldown -= delta
	if cooldown > 0: return
	
	# Frequencia: monstros por minutos
	# 60 monstros/minuto -> 1 monstro por seg
	# 120 monstros/minuto = 2 monstro por seg
	# 60 / 60 = 1
	# 60 / 120 = 0.5
	# 60 / 30 = 2
	var interval = 60.0 / mobs_per_minute
	cooldown = interval
	
	# Instanciar uma criatura aleatória
	var index = randi_range(0,  creatures.size()-1)
	# - pegar criatura aleatoria
	var creature_scene = creatures[index]
	# - pegar ponto aleatorio
	# - instanciar cena
	var creature = creature_scene.instantiate()
	# - colocar na posição certa
	creature.global_position = get_point()
	# - definir o parent => colocar realmente na cena
	get_parent().add_child(creature)
	
	

func get_point() -> Vector2:
	path_follow_2d.progress_ratio = randf()
	return path_follow_2d.global_position
