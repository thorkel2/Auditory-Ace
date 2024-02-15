extends Node2D

func _on_cancel_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/exercise_one.tscn")

func _on_profile_pressed():
	get_tree().change_scene_to_file("res://Scenes/profile.tscn")

func _on_help_pressed():
	get_tree().change_scene_to_file("res://Scenes/help.tscn")

func _on_home_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
