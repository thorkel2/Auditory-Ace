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
@onready var TTS = TextToSpeech
@onready var DB = Database
var Voices: Array[String]

func _ready():
	#Initializing Background Noise volume sliders
	$"Background Noise 1/VolumeSlider".value = BG1.volume_db
	$"Background Noise 2/VolumeSlider".value = BG2.volume_db
	$"Background Noise 3/VolumeSlider".value = BG3.volume_db
	#Initializing TTS voice options and volume slider
	Voices = TTS.getVoices()
	$TTS/VolumeSlider.value = TTS.Volume
	var Count: int = 0
	for i in Voices:
		$TTS/OptionButton.add_item(i, Count)
		Count += 1
	$TTS/OptionButton.selected = TTS.Voice
		
func onBG1Switched(toggled_on):
	if (toggled_on):
		BG1Playing = true
		BG1.play()
	else:
		BG1Playing = false
		BG1.stop()

func onBG2Switched(toggled_on):
	if (toggled_on):
		BG2Playing = true
		BG2.play()
	else:
		BG2Playing = false
		BG2.stop()

func onBG3Switched(toggled_on):
	if (toggled_on):
		BG3Playing = true
		BG3.play()
	else:
		BG3Playing = false
		BG3.stop()

func BG1Finished():
	if (BG1):
		BG1.play()
	
func BG2Finished():
	if (BG2):
		BG2.play()

func BG3Finished():
	if (BG3):
		BG3.play()

func textSubmitted(new_text):
	TTS.playText(new_text)

func voiceSelected(index):
	TTS.Voice = index
	DB.updateSetting("Default", "Sound", index)
	
func TTSVolumeChanged(value):
	TTS.Volume = value
	DB.updateSetting("Default", "Volume", value)

func BG1VolumeChanged(value):
	BG1.volume_db = value


func BG2VolumeChanged(value):
	BG2.volume_db = value


func BG3VolumeChanged(value):
	BG3.volume_db = value

