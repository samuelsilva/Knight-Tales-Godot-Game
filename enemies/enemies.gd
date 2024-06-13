class_name Enemy
extends Node2D

@export_category("Life")
@export var health: int = 20
@export var death_prefab: PackedScene
var damage_digit_prefab: PackedScene

@export_category("Drops")
@export var drop_chance: float = 0.1
@export var drop_items: Array[PackedScene]
@export var drop_chances: Array[float]

@onready var damage_digit_marker = $DamageDigitMarker

func _ready():
	damage_digit_prefab = preload("res://misc/damage_digit.tscn")

func damage(amount: int):
	health -= amount
	#print("Inimigo recebeu dano de ", amount, "A vida total é de ", health)
	
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
	# caveira
	if death_prefab:
		# instanciar o objeto
		var death_object = death_prefab.instantiate()
		# colocar o objeto na posição do personagem morto
		death_object.position = position
		#registra o objeto na cena
		get_parent().add_child(death_object)
	# drop
	
	if randf()	<= drop_chance:
		drop_item()
	
	# incrementar contador
	GameManager.monsters_defeated_counter += 1
	# deletar node
	queue_free()

func drop_item():
	var drop = get_random_drop_item().instantiate()
	drop.position = position
	get_parent().add_child(drop)
	

func get_random_drop_item() -> PackedScene:
	# Listas com 1 item
	if drop_items.size() == 1:
		return drop_items[0]
	
	# Calcular chance máxima
	var max_chance: float = 0.0
	for drop_chance in drop_chances:
		max_chance += drop_chance
	# jogar dado
	var random_value = randf() * max_chance
	
	# Girar a roleta
	var needle: float = 0.0
	for i in drop_items.size():
		var drop_item = drop_items[i]
		var drop_chance = drop_chances[i] if i < drop_chances.size() else 1
		if random_value <= drop_chance + needle:
			return drop_item
		needle += drop_chance
		
	return drop_items[0]
