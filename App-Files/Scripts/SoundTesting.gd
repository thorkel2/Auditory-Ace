extends Node2D
#Script for testing sounds and background noise
@onready var BG1 = $"Background Noise 1/AudioStreamPlayer"
@onready var BG2 = $"Background Noise 2/AudioStreamPlayer"
@onready var BG3 = $"Background Noise 3/AudioStreamPlayer"
@onready var TTS = TextToSpeech

var BG1Playing = false
var BG2Playing = false
var BG3Playing = false

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
