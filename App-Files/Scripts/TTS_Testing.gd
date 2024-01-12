extends Node
#Test script for TTS
@onready var TTS = TextToSpeech

func _ready():
	TTS.PlayText("Hello Auditory Ace Team")

