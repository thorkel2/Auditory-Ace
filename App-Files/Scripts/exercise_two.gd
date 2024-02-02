extends Button


#func load_next_scene():
#	LoadingScreen.load_scene("res://Scenes/ExerciseTwo")

func _on_pressed():
	get_tree().change_scene_to_file("res://Scenes/pre_exercise_two_screen.tscn")
