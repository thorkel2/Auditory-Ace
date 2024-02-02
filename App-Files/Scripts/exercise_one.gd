extends Button

#func load_next_scene():
#	LoadingScreen.load_scene("res://Scenes/ExerciseOne")

func _on_pressed():
	get_tree().change_scene_to_file("res://Scenes/pre_exercise_one_screen.tscn")
