extends Node2D

func _on_profile_pressed():
	get_tree().change_scene_to_file("res://Scenes/profile.tscn")

func _on_help_pressed():
	get_tree().change_scene_to_file("res://Scenes/help.tscn")

func _on_home_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_excercise_one_pressed():
	Globals.backscene = "res://Scenes/exercise_one.tscn"
	get_tree().change_scene_to_file("res://Scenes/pre_exercise_screen.tscn")

func _on_excercise_two_pressed():
	Globals.backscene = "res://Scenes/exercise_two.tscn"
	get_tree().change_scene_to_file("res://Scenes/pre_exercise_screen.tscn")
