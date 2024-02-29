#Testing script for Statistics
extends Node2D

func searchEntries():
	var entries = Database.searchEntries($SearchParameters/SearchDays.text, 
	$SearchParameters/SearchBGNoise.text, $SearchParameters/SearchSound.text, $SearchParameters/SearchExercise.text)
	#Reset text objects
	$TextElements/EntryTable/Date.text = ""
	$TextElements/EntryTable/Score.text = ""
	$TextElements/EntryTable/Time.text = ""
	$TextElements/EntryTable/BGNoise.text = ""
	$TextElements/EntryTable/Sound.text = ""
	$TextElements/EntryTable/Exercise.text = ""
	
	#Set text of text objects based on entries returned
	for n in range (0, entries.size(), 1):
		$TextElements/EntryTable/Date.text += entries[0][n] + "\n"
		$TextElements/EntryTable/Score.text += str(entries[1][n]) + "\n"
		#$TextElements/EntryTable/Time.text += str(entries[n]["Time"]) + "\n"
		#$TextElements/EntryTable/BGNoise.text += str(entries[n]["BackgroundNoise"]) + "\n"
		#$TextElements/EntryTable/Sound.text += entries[n]["Sound"] + "\n"
		#$TextElements/EntryTable/Exercise.text += entries[n]["Exercise"] + "\n"
		if (n == 13):
			break

#Button that generates entries with random data
func generateRandomEntries():
	Database.addRandomEntry(50)
