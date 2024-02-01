#This script contains the function for playing text via Text-to-Speech
#To play a string, create a var that contains the TextToSpeech class: "@onready var TTS = TextToSpeech"
#Then, simply call the "playText" function to play string: TTS.playText("Insert text here")
extends Node

class_name TTS
#Contains the voices that are usable
var voices = DisplayServer.tts_get_voices() 

var Voice : int
var Volume : int

#Will play text inputted via TTS
func playText(text : String): 
	DisplayServer.tts_speak(text, voices[Voice]["id"], Volume)

#Returns the names of all voices in system
func getVoices(): 
	var Voices: Array[String]
	for i in voices:
		Voices.append(i["name"])
	return Voices
	
	
