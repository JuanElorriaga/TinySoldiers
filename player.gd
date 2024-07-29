class_name Player
extends CharacterBody2D

@export var speed: float = 3
@export var sword_damage: int = 2
@export var health: int = 100
@export var death_prefab: PackedScene
@export var max_health: int = 100


@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var swordArea: Area2D = $SwordArea
@onready var HitBoxArea: Area2D = $HitBoxArea
@onready var Health_ProgressBar: ProgressBar = $HealthProgressBar

var input_vector = Vector2(0,0)
var is_running: bool = false
var was_running: bool = false
var is_attacking: bool = false
var attack_cooldown: float = 0.0
var deadzone = 0.15
var Hitbox_couldown: float = 0.0

signal meat_collected(value: int)

func _ready():
	GameManager.player = self

func _process(delta: float) -> void:
	GameManager.player_position = position
	read_input()

	# Processar ataque
	update_attack_cooldown(delta)
	if Input.is_action_just_pressed("attack"):
		attack()
	
	# Processar animação e rotação de sprite
	play_run_idle_animation()
	if not is_attacking:
		rotate_sprite()
		
	#processar dano
	update_HitBox_detection(delta)
	
	Health_ProgressBar.max_value = max_health
	Health_ProgressBar.value = health


func _physics_process(delta: float) -> void:
	# Modificar a velocidade
	var target_velocity = input_vector * delta * 20000.0
	if is_attacking:
		target_velocity *= 0.25
	velocity = lerp(velocity, target_velocity, 0.05)
	move_and_slide()


func update_attack_cooldown(delta: float) -> void:
	# Atualizar temporizador do ataque
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
			is_attacking = false
			is_running = false
			animation_player.play("idle")


func read_input() -> void:
	# Obter o input vector
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down", deadzone)
	
	# Apagar deadzone do input vector
	if abs(input_vector.x) < 0.15:
		input_vector.x = 0.0
	if abs(input_vector.y) < 0.15:
		input_vector.y = 0.0
	
	# Atualizar o is_running
	was_running = is_running
	is_running = not input_vector.is_zero_approx()


func play_run_idle_animation() -> void:
	# Tocar animação
	if not is_attacking:
		if was_running != is_running:
			if is_running:
				animation_player.play("run")
			else:
				animation_player.play("idle")


func rotate_sprite() -> void:
	# Girar sprite
	if input_vector.x > 0:
		sprite.flip_h = false
	elif input_vector.x < 0:
		sprite.flip_h = true


func attack() -> void:
	if is_attacking:
		return
	
	# Tocar animação
	animation_player.play("attack_side_1")
	
	# Configurar temporizador
	attack_cooldown = 0.6
	
	# Marcar ataque
	is_attacking = true
	
func deal_damage_to_enemies():
	
	var bodies = swordArea.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy= body
			
			var directiontoenemy = (enemy.position - position).normalized()
			var attack_direction: Vector2
			
			if sprite.flip_h:
					attack_direction = Vector2.LEFT
					var ataqueesquerda = directiontoenemy.dot(attack_direction) 
					if ataqueesquerda >= 0.5:
						enemy.damage(sword_damage)
					#print("valor",directiontoenemy.dot(attack_direction))
			else:
				attack_direction = Vector2.RIGHT
				var dot_product = directiontoenemy.dot(attack_direction)
				if dot_product >= 0.3:
					enemy.damage(sword_damage)
				#	print("Valor",dot_product)
				
				
func update_HitBox_detection(delta: float) -> void:
	#temporizador
	Hitbox_couldown -= delta
	if Hitbox_couldown > 0: return
	#frequencia
	Hitbox_couldown = 0.5
	#detectar inimigos
	var bodies = HitBoxArea.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			var damage_amount = 1
			damage(damage_amount)

func damage(amount: int) -> void:
	if health <= 0: return
	health -= amount
	print(health)
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self,"modulate", Color.WHITE, 0.3)
	
	if health <= 0:
		die()

func die() -> void:
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
		
		queue_free()
				
func heal(amount: int):
	health += amount
	if health > max_health:
		health = max_health
		return health
