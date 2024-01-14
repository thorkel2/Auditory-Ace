extends Node
#Test script for TTS
@onready var TTS = TextToSpeech

func _ready():
	TTS.playText("Hello Auditory Ace Team")

