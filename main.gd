extends Node


@export var  game_ui: CanvasLayer
@export var game_over_ui_template: PackedScene
@onready var adventure_music = $adventure_music as AudioStreamPlayer


func _ready():
	GameManager.game_over.connect(trigger_game_over)

func trigger_game_over():
	if game_ui:
		game_ui.queue_free()
		game_ui = null
		
		
		var game_over_ui: GameOverUi = game_over_ui_template.instantiate()
		add_child(game_over_ui)

