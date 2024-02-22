#Script for testing sounds and background noise
#Contains framework for all sound related functions, can be used as reference for actual implementation
extends Node2D

#Background Noise 1
@onready var BG1 = $"Background Noise 1/AudioStreamPlayer"
var BG1Playing = false

#Background Noise 2
@onready var BG2 = $"Background Noise 2/AudioStreamPlayer"
var BG2Playing = false

#Background Noise 3
@onready var BG3 = $"Background Noise 3/AudioStreamPlayer"
var BG3Playing = false

#Custom TTS
var Voices: Array[String]

func _ready():
	#Initializing TTS voice options and volume slider
	Voices = TextToSpeech.getVoices()
	$TTS/VolumeSlider.value = TextToSpeech.Volume
	var Count: int = 0
	for i in Voices:
		$TTS/OptionButton.add_item(i, Count)
		Count += 1
	$TTS/OptionButton.selected = TextToSpeech.Voice

func textSubmitted(new_text):
	TextToSpeech.playText(new_text)

func voiceSelected(index):
	TextToSpeech.Voice = index
	Database.updateSetting("TTS", "Sound", index)
	
func TTSVolumeChanged(value):
	TextToSpeech.Volume = value
	Database.updateSetting("TTS", "Volume", value)

func bgButton():
	Audio.playBGNoise()

func editBGSound(new_text):
	Audio.changeBGSound("BG", "'" + new_text + "'")

func editBGVolume(new_text):
	Audio.changeBGVolume("BG", int(new_text))
	
func editFXSound(new_text):
	Audio.playFX(new_text)
	
func editFXVolume(new_text):
	Audio.changeFXVolume(int(new_text))
