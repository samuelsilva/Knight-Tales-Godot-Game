extends CharacterBody2D

@export var speed: float = 3.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var input_vector: Vector2 = Vector2(0, 0)
var is_running: bool = false
var was_running: bool = false
var is_attacking: bool = false
var attack_cooldown: float = 0.0


func _process(delta):
	# ler input
	read_input()
	# Processar ataque
	update_attack_cooldown(delta)
	if Input.is_action_just_pressed("attack"):
		attack()
	# Processar animação e rotação de sprite
	play_run_idle_animation()
	rotate_sprite()


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
