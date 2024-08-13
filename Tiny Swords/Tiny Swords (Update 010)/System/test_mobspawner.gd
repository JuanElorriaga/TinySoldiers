class_name MobSpawner
extends Node2D

@export var creatures: Array[PackedScene]
var mobs_per_minute: float = 60.0

@onready var path_follow2D: PathFollow2D = %PathFollow2D
var cooldown: float = 0.0

func _process(delta: float):
	if GameManager.is_game_over: return
	cooldown -= delta
	if cooldown > 0: return
	
	var interval = 60.0 / mobs_per_minute
	cooldown = interval
	
	var point = get_point()
	var worldstate = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = point
	parameters.collision_mask = 0b1001
	var result = worldstate.intersect_point(parameters, 1)

	
	var index = randi_range(0, creatures.size() - 1)
	var creature_scene = creatures[index]
	var creature = creature_scene.instantiate()
	creature.global_position = point
	get_parent().add_child(creature)


func get_point() -> Vector2:
	path_follow2D.progress_ratio = randf()
	return path_follow2D.global_position
