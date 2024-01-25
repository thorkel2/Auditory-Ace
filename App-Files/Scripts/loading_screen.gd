extends Node2D

func load_next_scene():
	ResourceLoader.load_threaded_request("res://main_menu.tscn")
	get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get("res://main_menu.tcsn"))
	
@onready var loading_screen_scene = preload("res://Scenes/loading_screen.tscn")

var scene_to_load_path
var loading_screen_scene
var loading = false

func load_scene(path)
	var current_scene
