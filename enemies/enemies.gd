class_name Enemy
extends Node2D

@export var health: int = 10
@export var death_prefab: PackedScene
var damage_digit_prefab: PackedScene

@onready var damage_digit_marker = $DamageDigitMarker

func _ready():
	damage_digit_prefab = preload("res://misc/damage_digit.tscn")

func damage(amount: int):
	health -= amount
	print("Inimigo recebeu dano de ", amount, "A vida total é de ", health)
	
	# piscar inimigo a cada dano sofrido
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN) # seta  o tipo de EASE
	tween.set_trans(Tween.TRANS_QUINT)  # seta o tipo de transição das cores
	tween.tween_property(self,"modulate",Color.WHITE, 0.3)
	
	# criar damagedigit
	
	var damage_digit = damage_digit_prefab.instantiate()
	damage_digit.value = amount
	if damage_digit_marker:
		damage_digit.global_position = damage_digit_marker.global_position 
	else:
		damage_digit.global_position = global_position 
	get_parent().add_child(damage_digit) # adicionar na cena
	
	# processar morte (vida igual ou menor que zero)
	if health <= 0:
		die()
	

func die():
	if death_prefab:
		# instanciar o objeto
		var death_object = death_prefab.instantiate()
		# colocar o objeto na posição do personagem morto
		death_object.position = position
		
		#registra o objeto na cena
		get_parent().add_child(death_object)
	queue_free()
