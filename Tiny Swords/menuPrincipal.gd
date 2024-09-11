extends Control
@onready var mainMenu = $mainMenu as AudioStreamPlayer



func _on_btn_start_pressed():
	get_tree().change_scene_to_file("res://main.tscn")


func _on_btn_credits_pressed():
	get_tree().change_scene_to_file("res://Tiny Swords/credits.tscn")


func _on_btn_quit_pressed():
	get_tree().quit()
