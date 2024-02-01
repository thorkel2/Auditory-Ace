extends Node
#Database 
var db #database object
var db_name  #path to database on device

#Search filters
var searchDays : String = "NULL"
var searchBGNoise : String = "NULL"
var searchSound : String = "NULL"
var searchExercise : String = "NULL"

#Initial Loadup
func _ready():
	match OS.get_name():
		"Windows":
			print("OS: Windows")
			db_name = "res://Database/database"
		"Android":
			print("OS: Android")
			db_name = "user://database"
			
	db = SQLite.new()
	db.path = db_name
	loadTables()
	TextToSpeech.playText("Welcome, to Auditory Ace")

#Initial loading of data
func loadTables():	
	db.open_db()
	db.query("SELECT name FROM sqlite_master WHERE type='table' AND name= 'Settings';")
	
	#If database does not exist, create database
	if (db.query_result.size() != 1):
		db.query("CREATE TABLE Settings (Name VARCHAR(255), Sound INT, Volume INT);")
		db.query("INSERT INTO Settings (Name, Sound, Volume) VALUES ('Default', 0, 50);")
		db.query("CREATE TABLE Entries (Date TIMESTAMP, Score INT, Time FLOAT, BackgroundNoise INT, Sound VARCHAR(255), Exercise VARCHAR(255));")
		print("Created table")
		
	#Load default sound settings
	db.query("SELECT * FROM Settings WHERE Name = 'Default';")
	TextToSpeech.Voice = db.query_result[0]["Sound"]
	TextToSpeech.Volume = db.query_result[0]["Volume"]
	db.close_db()
	
#Update value of setting based on name
func updateSetting(category : String, setting : String, value):
	db.open_db()
	db.query("UPDATE Settings SET " + setting + " = " + str(value) + " WHERE Name = '" + category + "';")
	db.close_db()
	
#Add entry based on parameters
func addEntry(score : int, time : float, bgNoise : String, sound : String, exercise : String):
	db.open_db()
	db.query("INSERT INTO Entries (Date, Score, Time, BackgroundNoise, Sound, Exercise) VALUES (CURRENT_TIMESTAMP, " 
	+ str(score) + ", " + str(time) + ", '" + bgNoise + "', '" + sound + "', '" + exercise + "');")
	db.close_db()
	
#Search for entries based on parameters
func searchEntries():
	db.open_db() 
	var Query : String = "SELECT * FROM (SELECT * FROM Entries ORDER BY Date Desc) AS SortedEntries "
	
	if (searchDays == "All" && searchBGNoise == "All" && searchSound == "All" && searchExercise == "All"):
		db.query(Query)
	else:
		var filter = ["NULL", "NULL", "NULL", "NULL"]
		if (searchDays != "All"):
			filter[0] = searchDays
			Query += "WHERE Date >= date('now', '-" + filter[0] + " days') AND (BackgroundNoise = COALESCE("
		else:
			Query += "WHERE (BackgroundNoise = COALESCE("
			
		if (searchBGNoise != "All"):
			filter[1] = "'" + searchBGNoise + "'"
		
		if (searchSound != "All"):
			filter[2] = "'" + searchSound + "'"
			
		if (searchExercise != "All"):
			filter[3] = "'Exercise " + searchExercise + "'"
			
		Query += filter[1] + ", BackgroundNoise))
		AND (Sound = COALESCE(" + filter[2] + ", Sound))
		AND (Exercise = COALESCE(" + filter[3] + ", Exercise));"
		db.query(Query)
	
	var results = db.query_result
	db.close_db()
	return(results)	

#Randomly generates x amount of entries (testing purposes)
func addRandomEntry(num : int):
	var sounds = ["aw", "ee", "ir", "owe", "er", "i", "ear", "or"]
	db.open_db()
	for n in 100:
		var day : int = randi_range(1, 30)
		var randomTime : String
		if (day < 10):
			randomTime = "'2024-01-0" + str(day) + " " + str(randi_range(1, 12)) + ":" + str(randi_range(10, 59)) + ":" + str(randi_range(10, 59)) + "'"
		else:
			randomTime = "'2024-01-" + str(day) + " " + str(randi_range(1, 12)) + ":" + str(randi_range(10, 59)) + ":" + str(randi_range(10, 59)) + "'"
		var score : String = str(randi_range(1, 1000))
		var time : String = str(randi_range(1, 10))
		var bgNoise : String = str(randi_range(1, 10))
		var sound : String = sounds[randi_range(0, sounds.size() - 1)]
		var exercise : String = "Exercise " + str(randi_range(1, 2))
		
		db.query("INSERT INTO Entries (Date, Score, Time, BackgroundNoise, Sound, Exercise) VALUES ("
		+ randomTime + ", " + score + ", " + time + ", '" + bgNoise + "', '" + sound + "', '" + exercise + "');")
	db.query("SELECT * FROM Entries ORDER BY Date;")
	db.close_db()
	

