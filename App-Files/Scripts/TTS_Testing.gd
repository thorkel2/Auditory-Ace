#Testing script for TTS 
extends Node

@onready var TTS = TextToSpeech

func _ready():
	TTS.playText("Hello Auditory Ace Team")


