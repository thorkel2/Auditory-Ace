extends Node2D
@onready var wordlistDD = $ColorRect/WordListDropdown
@onready var bgnoiseDD = $ColorRect/BGNoiseDropdown
@onready var exerciseDD = $ColorRect/Exercise

func _ready():
	if(Globals.wordlist == "All"):
		wordlistDD.selected = 0;
	if(Globals.wordlist == "MvN"):
		wordlistDD.selected = 1;
	if(Globals.wordlist == "SvF"):
		wordlistDD.selected = 2;
	if(Globals.wordlist == "TvP"):
		wordlistDD.selected = 3;
	if(Globals.bgnoises == "All"):
		bgnoiseDD.selected = 0;
	if(Globals.bgnoises == "Low"):
		bgnoiseDD.selected = 1;
	if(Globals.bgnoises == "Medium"):
		bgnoiseDD.selected = 2;
	if(Globals.bgnoises == "High"):
		bgnoiseDD.selected = 3;
	if(Globals.bgnoises == "None"):
		bgnoiseDD.selected = 4;	
	if(Globals.exercise == "All"):
		exerciseDD.selected = 0;
	if(Globals.exercise == "1"):
		exerciseDD.selected = 1;
	if(Globals.exercise == "2"):
		exerciseDD.selected = 2;
func _on_profile_pressed():
	Globals.wordlist = null;
	Globals.bgnoises = null;
	Globals.exercise = null;
	get_tree().change_scene_to_file("res://Scenes/profile.tscn")

func _on_help_pressed():
	Globals.wordlist = null;
	Globals.bgnoises = null;
	Globals.exercise = null;
	get_tree().change_scene_to_file("res://Scenes/help.tscn")

func _on_home_pressed():
	Globals.wordlist = null;
	Globals.bgnoises = null;
	Globals.exercise = null;
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	
	
