extends Node2D
@onready var BGLow = $"BG Noise Buttons/BGLow"
@onready var BGMedium = $"BG Noise Buttons/BGMedium"
@onready var BGHigh = $"BG Noise Buttons/BGHigh"
var onButton = preload("res://Artwork/starGreen.png") # Preload image
var offButton = preload("res://Artwork/starGrey.png") # Preload image
var lastVolumePressed # Last button user pressed
var Voices: Array[String]
var playing = false

func _ready():
	#Initializing TTS voice options and volume slider
	Voices = TextToSpeech.getVoices()
	var Count: int = 0
	for i in Voices:
		$"TTS Buttons/TTS Dropdown".add_item(i, Count)
		Count += 1
	$"TTS Buttons/TTS Dropdown".selected = TextToSpeech.Voice

func textSubmitted(new_text):
	TextToSpeech.playText(new_text)

func voiceSelected(index):
	if (index != 0):
		TextToSpeech.Voice = index - 1
		Database.updateSetting("TTS", "Sound", str(index - 1))
	
func TTSVolumeChanged(value):
	TextToSpeech.Volume = value
	Database.updateSetting("TTS", "Volume", value)

func bgButton():
	if !playing:
		Audio.playBGNoise()
		playing = true
	else:
		Audio.stopBGNoise()
		playing = false
	
func editFXSound(new_text):
	Audio.playFX(new_text)
	
func editFXVolume(new_text):
	Audio.changeFXVolume(new_text)
	
func BGLowPressed():
	Audio.changeBGVolume("BG", "Low")
	BGButtonsLogic(BGLow)

func BGMediumPressed():
	Audio.changeBGVolume("BG", "Medium")
	BGButtonsLogic(BGMedium)

func BGHighPressed():
	Audio.changeBGVolume("BG", "High")
	BGButtonsLogic(BGHigh)

func BGButtonsLogic(buttonPressed):
	lastVolumePressed = buttonPressed
	var buttonArray = [BGLow, BGMedium, BGHigh]
	
	for button in buttonArray:
		if(buttonPressed == button):
			button.set_texture_normal(onButton)
		else:
			button.set_texture_normal(offButton)
			
func bgNoiseSelected(index):
	match index:
		1:
			Audio.changeBGVolume("BG", "None")
		2:
			Audio.changeBGSound("BG", "Announcer")
		3:
			Audio.changeBGSound("BG", "Bus Interior")
		4:
			Audio.changeBGSound("BG", "Food Court")
