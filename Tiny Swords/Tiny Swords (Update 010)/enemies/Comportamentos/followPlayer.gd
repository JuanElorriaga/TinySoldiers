extends Node
@export var speed: float = 1

#@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var enemy: Enemy
var sprite: AnimatedSprite2D


func _ready():
	enemy = get_parent()
	sprite = enemy.get_node("AnimatedSprite2D")

func _physics_process(delta):
	if GameManager.is_game_over: return
	#calcula direcao
	var player_position = GameManager.player_position
	var difference = player_position - enemy.position
	var input_vector = difference.normalized()
	#movimento
	enemy.velocity = input_vector * delta * 10000.0
	
	enemy.move_and_slide()
	
	# Girar sprite
	if input_vector.x > 0:
		sprite.flip_h = false
	elif input_vector.x < 0:
		sprite.flip_h = true
