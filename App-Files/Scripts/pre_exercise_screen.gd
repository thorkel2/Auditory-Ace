extends Node2D

@onready var BGLow = $Background/ColorRect/BGLow
@onready var BGMedium = $Background/ColorRect/BGMedium
@onready var BGHigh = $Background/ColorRect/BGHigh
@onready var BGOptionsButton = $VBoxContainer/BGNoiseDropdown
@onready var descriptionText = $Background/ColorRect/DescriptionText


var Voices: Array[String] # Array to hold available system voices
var onButton = preload("res://Artwork/starGreen.png") # Preload image
var offButton = preload("res://Artwork/starGrey.png") # Preload image
var lastVolumePressed # Last button user pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	# Choosing random word list in case user doesn't pick
	WordListManager.setWordListVar(randi() % 3 + 1)
	
	# Default lastVolumePressed to low
	lastVolumePressed = BGLow
	
	# Default bgLevel to None
	_on_bg_noise_dropdown_item_selected(0)
	
	
	if(Globals.backscene == "res://Scenes/exercise_one.tscn"):
		descriptionText.text = "Let’s practice 
hearing and differentiating between similar-sounding words!"
	else:
		descriptionText.text = "Let’s practice 
hearing and differentiating between similar-sounding words in sentences!"
	
	# Setting TTS voice options
	Voices = TextToSpeech.getVoices()
	for voice in Voices:
		$VBoxContainer/TTSDropdown.add_item(voice)

# Scene change functions
func _on_cancel_pressed():
	Audio.stopBGNoise()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_start_pressed():
	get_tree().change_scene_to_file(Globals.backscene)

func _on_profile_pressed():
	Audio.stopBGNoise()
	get_tree().change_scene_to_file("res://Scenes/profile.tscn")

func _on_help_pressed():
	Audio.stopBGNoise()
	get_tree().change_scene_to_file("res://Scenes/help.tscn")

func _on_home_pressed():
	Audio.stopBGNoise()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

# Button Functions
func _on_description_text_pressed():
	# Must change this line when changing description of exercise.
	# Can't use variable because it sounds weird with line breaks.
	if(Globals.backscene == "res://Scenes/exercise_one.tscn"):
		TextToSpeech.playText("Let’s practice hearing and differentiating between similar-sounding words!")
	else:
		TextToSpeech.playText("Let’s practice 
hearing and differentiating between similar-sounding words in sentences!")

func _on_word_list_dropdown_item_selected(index):
	if(index == 0):
		WordListManager.setWordListVar(randi() % 3 + 1)
	else:
		WordListManager.setWordListVar(index)

func _on_tts_dropdown_item_selected(index):
	# Set voice
	TextToSpeech.Voice = index
	Database.updateSetting("TTS", "Sound", str(index))
	
	# Play voice for user
	TextToSpeech.playText("Hello")

func _on_bg_noise_dropdown_item_selected(index):
	# Disable volume options if user picked none
	if(index == 0):
		WordListManager.bgLevel = "None"
		BGLow.set_texture_normal(offButton)
		BGMedium.set_texture_normal(offButton)
		BGHigh.set_texture_normal(offButton)
		BGLow.set_disabled(true)
		BGMedium.set_disabled(true)
		BGHigh.set_disabled(true)
		Audio.changeBGSound("BG", BGOptionsButton.get_item_text(index))
		Audio.stopBGNoise()
	else:
		# Otherwise enable buttons and set to latest volume
		BGLow.set_disabled(false)
		BGMedium.set_disabled(false)
		BGHigh.set_disabled(false)
		BGButtonsLogic(lastVolumePressed)
		
		Audio.changeBGSound("BG", BGOptionsButton.get_item_text(index))
		Audio.playBGNoise()


# The four BG buttons "turn off" the other BG buttons when one is pressed
func _on_bg_low_pressed():
	BGButtonsLogic(BGLow)

func _on_bg_medium_pressed():
	BGButtonsLogic(BGMedium)

func _on_bg_high_pressed():
	BGButtonsLogic(BGHigh)

# Background volume button on/off logic
func BGButtonsLogic(buttonPressed):
	lastVolumePressed = buttonPressed
	var buttonArray = [BGLow, BGMedium, BGHigh]
	
	for button in buttonArray:
		if(buttonPressed == button):
			button.set_texture_normal(onButton)
		else:
			button.set_texture_normal(offButton)
	
	match buttonPressed:
		BGLow:
			TextToSpeech.playText("Low")
			WordListManager.bgLevel = "Low"
			Audio.changeBGVolume("BG", "Low")
		BGMedium:
			TextToSpeech.playText("Medium")
			WordListManager.bgLevel = "Medium"
			Audio.changeBGVolume("BG", "Medium")
		BGHigh:
			TextToSpeech.playText("High")
			WordListManager.bgLevel = "High"
			Audio.changeBGVolume("BG", "High")
	
	Audio.playBGNoise()
