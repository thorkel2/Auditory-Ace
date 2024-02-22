extends Node2D

var Voices: Array[String] # Array to hold available system voices
var onButton = preload("res://Artwork/starGreen.png") # Preload image
var offButton = preload("res://Artwork/starGrey.png") # Preload image

# Called when the node enters the scene tree for the first time.
func _ready():
	# Choosing random word list in case user doesn't pick
	WordListManager.setWordListVar(randi() % 3 + 1)
	
	# BG Noise Turned off by default
	$Background/ColorRect/BGNone.set_texture_normal(onButton)
	
	# Setting TTS voice options
	Voices = TextToSpeech.getVoices()
	for voice in Voices:
		$Background/ColorRect/TTSDropdown.add_item(voice)

# Scene change functions
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

# Button Functions
func wordListDropdownItemSelected(index):
	WordListManager.setWordListVar(index)

func TTSDropdownItemSelected(index):
	# Decreases index by 1 when not default to account for default
	if(index > 0):
		index += -1
	
	# Set voice
	TextToSpeech.Voice = index
	Database.updateSetting("Default", "Sound", index)
	
	# Play voice for user
	TextToSpeech.playText("Hello")

func BGNoiseDropdownItemSelected(index):
	# Setting BG noise. Doesn't work right now
	Audio.loadBGNoise($Background/ColorRect/BGNoiseDropdown.get_item_text(index))
	Audio.playBGNoise()
	

# The four BG buttons "turn off" the other BG buttons when one is pressed
# Likely a better way to code this... lol
func BGNonePressed():
	$Background/ColorRect/BGNone.set_texture_normal(onButton)
	$Background/ColorRect/BGLow.set_texture_normal(offButton)
	$Background/ColorRect/BGMedium.set_texture_normal(offButton)
	$Background/ColorRect/BGHigh.set_texture_normal(offButton)

func BGLowPressed():
	$Background/ColorRect/BGNone.set_texture_normal(offButton)
	$Background/ColorRect/BGLow.set_texture_normal(onButton)
	$Background/ColorRect/BGMedium.set_texture_normal(offButton)
	$Background/ColorRect/BGHigh.set_texture_normal(offButton)

func BGMediumPressed():
	$Background/ColorRect/BGNone.set_texture_normal(offButton)
	$Background/ColorRect/BGLow.set_texture_normal(offButton)
	$Background/ColorRect/BGMedium.set_texture_normal(onButton)
	$Background/ColorRect/BGHigh.set_texture_normal(offButton)

func BGHighPressed():
	$Background/ColorRect/BGNone.set_texture_normal(offButton)
	$Background/ColorRect/BGLow.set_texture_normal(offButton)
	$Background/ColorRect/BGMedium.set_texture_normal(offButton)
	$Background/ColorRect/BGHigh.set_texture_normal(onButton)
