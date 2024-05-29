class_name Player
extends CharacterBody2D

@export_category("Movement")
@export var speed: float = 3
@export_category("Sword")
@export var sword_damage: int = 2
@export_category("Ritual")
@export var ritual_damage: int = 2
@export var ritual_interval: float = 30
@export var ritual_scene: PackedScene
@export_category("Life")
@export var health: int = 100
@export var max_health: int = 100
@export var death_prefab: PackedScene


@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sword_area: Area2D = $SwordArea
@onready var hitbox_area: Area2D = $HitboxArea
@onready var health_progress_bar: ProgressBar = $HealthProgressBar

var input_vector: Vector2 = Vector2(0, 0)
var is_running: bool = false
var was_running: bool = false
var is_attacking: bool = false
var attack_cooldown: float = 0.0
var hitbox_cooldown: float = 0.0
var ritual_cooldown: float = 0.0


# toda vez que pegar uma carne vai gerar um sinal
signal meat_collected(value: int) 

func _ready():
	GameManager.player = self

func _process(delta):
	GameManager.player_position = position
	# ler input
	read_input()
	# Processar ataque
	update_attack_cooldown(delta)
	if Input.is_action_just_pressed("attack"):
		attack()
	# Processar animação e rotação de sprite
	play_run_idle_animation()
	if not is_attacking:
		rotate_sprite()
		
	#Processar o dano
	update_hitbox_detection(delta)

	# ritual
	update_ritual(delta)
	
	# Atualizar health progress bar
	health_progress_bar.max_value = max_health
	health_progress_bar.value = health


func _physics_process(delta):
	# modificar a velocidade
	var target_velocity = input_vector * speed * 100.0
	# reduzir a velocidade quando estiver atacando
	if is_attacking:
		target_velocity *= 0.25
	velocity = lerp(velocity, target_velocity, 0.05)
	move_and_slide()


func update_attack_cooldown(delta):
	# Atualizar temporizador do ataque
	if is_attacking: 
		attack_cooldown -= delta #0.6 - 0016
		if attack_cooldown <= 0.0:
			is_attacking = false
			is_running = false
			animation_player.play("idle")

func update_ritual(delta):
	#atualizar temporizador
	ritual_cooldown -= delta
	if ritual_cooldown > 0: return
	#resetar temporizador
	ritual_cooldown = ritual_interval
	
	# criar o ritual
	var ritual = ritual_scene.instantiate()
	# posição acompanha o player
	ritual.damage_amount = ritual_damage
	add_child(ritual)
	

func read_input():
	#obter input vector
	input_vector = Input.get_vector("move_left","move_right","move_up","move_down")
	# Apagar deadzone do input vector
	var deadzone = 0.15
	if abs(input_vector.x) < 0.15:
		input_vector.x = 0.0
	if abs(input_vector.y) < 0.15:
		input_vector.y = 0.0
	# Atualizar a animação
	was_running = is_running
	is_running = not input_vector.is_zero_approx()

func play_run_idle_animation():
	# Tocar animação
	if not is_attacking:
		if was_running != is_running:
			if is_running:
				animation_player.play("run")
			else:
				animation_player.play("idle")

func rotate_sprite(): 
	# Girar sprite
	if input_vector.x > 0:
		# desmarcar Flip H do Sprite2D
		sprite.flip_h = false
	elif input_vector.x < 0:
		# desmarcar Flip H do Sprite2D
		sprite.flip_h = true


func attack():
	if is_attacking:
		return
	
	# Tocar animação
	animation_player.play("attack_side_1")
	
	# Configurar temporizador
	attack_cooldown = 0.6	
	# Marcar ataque
	is_attacking = true
	
	# Aplicar dano nos inimigos
	#deal_damage_to_enemies()

func deal_damage_to_enemies():
	var bodies = sword_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			
			var direction_to_enemy = (enemy.position - position).normalized()
			var attack_direction: Vector2
			if sprite.flip_h:
				attack_direction = Vector2.LEFT
			else:
				attack_direction = Vector2.RIGHT
			var dot_product = direction_to_enemy.dot(attack_direction)
			print("Dot: ", dot_product)
			if dot_product >= 0.3:
				enemy.damage(sword_damage)

func update_hitbox_detection(delta):
	# Temporizador
	hitbox_cooldown -= delta
	if hitbox_cooldown > 0: return
	
	# Frequencia de dano (2x por segundo)
	hitbox_cooldown = 0.5 
	
	# HitboxArea
	# Pegar todos os corpos dentro de uma área
	var bodies = hitbox_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			var damage_amount = 1
			damage(damage_amount)
	


		
	# Acessar todos os inimigos
#	var enemies = get_tree().get_nodes_in_group("enemies")
#	for enemy in enemies:
#		enemy.damage(sword_damage)
#		pass
#	print("Enemies ", enemies.size())
	# Chamar a função "damage"
	# 	Com "sword_damage" como primeiro parametro
#	pass


func damage(amount: int):
	if health <= 0: return
	
	health -= amount
	print("Player recebeu dano de ", amount, "A vida total é de ", health, "/", max_health)
	
	# piscar inimigo a cada dano sofrido
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN) # seta  o tipo de EASE
	tween.set_trans(Tween.TRANS_QUINT)  # seta o tipo de transição das cores
	tween.tween_property(self,"modulate",Color.WHITE, 0.3)
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
	print("Player morreu!")
	queue_free()

func heal(amount: int) -> int:
	health += amount
	if health > max_health:
		health = max_health
	print("Player recebeu cura de ", amount, "A vida total é de ", health, "/", max_health)	
	return health
	
