extends Node2D

@onready var BGLow = $Background/ColorRect/BGLow
@onready var BGMedium = $Background/ColorRect/BGMedium
@onready var BGHigh = $Background/ColorRect/BGHigh

var Voices: Array[String] # Array to hold available system voices
var onButton = preload("res://Artwork/starGreen.png") # Preload image
var offButton = preload("res://Artwork/starGrey.png") # Preload image
var lastVolumePressed # Last button user pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	# Choosing random word list in case user doesn't pick
	WordListManager.setWordListVar(randi() % 3 + 1)
	
	# Default BG volume to low
	lastVolumePressed = BGLow
	
	# Disable BG options
	BGLow.set_disabled(true)
	BGMedium.set_disabled(true)
	BGHigh.set_disabled(true)
	
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
	# Disable volume options if user picked none
	if(index == 1):
		BGLow.set_texture_normal(offButton)
		BGMedium.set_texture_normal(offButton)
		BGHigh.set_texture_normal(offButton)
		BGLow.set_disabled(true)
		BGMedium.set_disabled(true)
		BGHigh.set_disabled(true)
	else:
		# If volume options are disabled re-enable and set to last pressed
		if(BGLow.is_disabled()):
			BGLow.set_disabled(false)
			BGMedium.set_disabled(false)
			BGHigh.set_disabled(false)
			BGButtonsLogic(lastVolumePressed)
		else:
			# Otherwise just re-enable
			BGLow.set_disabled(false)
			BGMedium.set_disabled(false)
			BGHigh.set_disabled(false)
		
		# Use Jordan's BG functions here. WIP
		
		
	

# The four BG buttons "turn off" the other BG buttons when one is pressed
# Likely a better way to code this... lol
func BGLowPressed():
	BGButtonsLogic(BGLow)

func BGMediumPressed():
	BGButtonsLogic(BGMedium)

func BGHighPressed():
	BGButtonsLogic(BGHigh)

# Background volume button logic
func BGButtonsLogic(buttonPressed):
	lastVolumePressed = buttonPressed
	var buttonArray = [BGLow, BGMedium, BGHigh]
	
	for button in buttonArray:
		if(buttonPressed == button):
			button.set_texture_normal(onButton)
		else:
			button.set_texture_normal(offButton)
