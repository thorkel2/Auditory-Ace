extends Node
#This script contains the function for playing text via Text-to-Speech
#To play a string, create a var that contains the TextToSpeech class: "@onready var TTS = TextToSpeech"
#Then, simply call the "playText" function to play string: TTS.playText("Insert text here")
class_name TTS

var voices = DisplayServer.tts_get_voices()
var voice = voices[0]

func playText(text): 
	var child = voice["name"]
	DisplayServer.tts_speak(text, child)
	
