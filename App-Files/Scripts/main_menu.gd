extends Node2D

func load_next_scene():
	LoadingScreen.load_scene("res://Scenes/exercise_one.tscn")

func _on_trigger_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/exercise_one.tscn")
