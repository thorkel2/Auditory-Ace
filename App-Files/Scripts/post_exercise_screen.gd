extends Node2D

var backscene = Globals.backscene;

func _on_cancel_pressed():
	get_tree().change_scene_to_file("res://Scenes/pre_exercise_screen.tscn")


func _on_done_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_profile_pressed():
	get_tree().change_scene_to_file("res://Scenes/profile.tscn")


func _on_help_pressed():
	get_tree().change_scene_to_file("res://Scenes/help.tscn")


func _on_home_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _ready():
	var wordListText
	match str(WordListManager.chosenWordList):
		'0':
			wordListText = 'M vs N'
		'1':
			wordListText = 'S vs F'
		'2':
			wordListText = 'T vs P'
	
	$UI/scoreVal.set_text(str(WordListManager.score))
	$UI/wordListVal.set_text(wordListText)
	$UI/bgVolumeVal.set_text(WordListManager.bgLevel)
	$UI/accVal.set_text(str(WordListManager.numCorrect) + "/5")
