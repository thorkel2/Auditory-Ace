#Script for the global audio scene which contains the objects that play sound effects and background noise
extends Node2D

func _ready():
	loadFXVolume()

#Loads the volume for sound effects from database 
func loadFXVolume():
	var volume = Database.retrieveSetting("SoundEffect")
	$SoundEffect.volume_db = volume[1]

#Changes the volume level of sound effects and loads it
func changeFXVolume(volume : int):
	Database.updateSetting("SoundEffect", "Volume", volume)
	loadFXVolume()
	
#Plays sound effect of the filename passed in
func playFX(sound : String):
	$SoundEffect.stream = load("res://Audio/" + sound + ".mp3")
	$SoundEffect.play()
	
#Loads the specific sound and volume levels for background noise from database
func loadBGNoise(BGNoise : String):
	var Setting = Database.retrieveSetting(BGNoise)
	$BackgroundNoise.stream = load("res://Audio/" + Setting[0] + ".mp3")
	$BackgroundNoise.volume_db = Setting[1]

#Changes the volume level of background noise and loads it
func changeBGVolume(setting : String, volume : int):
	Database.updateSetting(setting, "Volume", volume)
	loadBGNoise(setting)
	
#Changes the sound played of background noise and loads it
func changeBGSound(setting : String, sound : String):
	Database.updateSetting(setting, "Sound", sound)
	loadBGNoise(setting)
	
#Play background noise
func playBGNoise():
	$BackgroundNoise.play()

#Stop background noise
func stopBGNoise():
	$BackgroundNoise.stop()

