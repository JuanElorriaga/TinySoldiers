extends Control

@onready var mainMenu = $MainMenu as AudioStreamPlayer

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Tiny Swords/menuPrincipal.tscn")
