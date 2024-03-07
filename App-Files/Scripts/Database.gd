extends Node
#Database 
var db #database object
var db_name  #path to database on device

#Initial Loadup
func _ready():
	match OS.get_name():
		"macOS":
			print("OS: macOS")
			db_name = "res://Database/database"
		"Windows":
			print("OS: Windows")
			db_name = "res://Database/database"
		"Android":
			print("OS: Android")
			db_name = "user://database"
			
	db = SQLite.new()
	db.path = db_name
	loadTables()

#Initial loading of data
func loadTables():	
	db.open_db()
	db.query("SELECT name FROM sqlite_master WHERE type='table' AND name= 'Settings';")
	
	#If database does not exist, create database
	if (db.query_result.size() != 1):
		db.query("CREATE TABLE Settings (Name VARCHAR(255), Sound VARCHAR(255), Volume VARCHAR(255));")
		db.query("INSERT INTO Settings (Name, Sound, Volume) VALUES ('TTS', 0, '50');")
		db.query("INSERT INTO Settings (Name, Sound, Volume) VALUES ('SoundEffect', 0, '-12');")
		db.query("CREATE TABLE Entries (Date TIMESTAMP, Score INT, Time FLOAT, BackgroundNoise VARCHAR(255), Sound VARCHAR(255), Exercise VARCHAR(255));")
		print("Created table")
	db.close_db()
	#Load default sound settings
	var Setting = retrieveSetting("TTS")
	TextToSpeech.Voice = int(Setting[0])
	TextToSpeech.Volume = int(Setting[1])
	
	
#Retrieve specific sound settings based on name
func retrieveSetting(setting : String):
	db.open_db()
	db.query("SELECT * FROM Settings WHERE Name = '" + setting + "';")
	if (db.query_result.size() < 1):
		db.query("INSERT INTO Settings (Name, Sound, Volume) VALUES ('" + setting + "', 'None', -12);")
		db.query("SELECT * FROM Settings WHERE Name = '" + setting + "';")
	var Setting = [db.query_result[0]["Sound"], db.query_result[0]["Volume"]]
	db.close_db()
	return Setting
	
#Update value of setting based on name
func updateSetting(settingName : String, settingCategory : String, settingValue : String):
	db.open_db()
	db.query("SELECT * FROM Settings WHERE Name = '" + settingName + "';")
	if (db.query_result.size() < 1):
		db.query("INSERT INTO Settings (Name, Sound, Volume) VALUES ('" + settingName + "', 0, 'None');")
	db.query("UPDATE Settings SET '" + settingCategory + "' = '" + settingValue + "' WHERE Name = '" + settingName + "';")
	db.close_db()
	
#Add entry based on parameters
func addEntry(score : int, time : float, bgNoise : String, sound : String, exercise : String):
	db.open_db()
	db.query("INSERT INTO Entries (Date, Score, Time, BackgroundNoise, Sound, Exercise) VALUES (CURRENT_TIMESTAMP, " 
	+ str(score) + ", " + str(time) + ", '" + bgNoise + "', '" + sound + "', '" + exercise + "');")
	db.close_db()
	
#Search for entries based on parameters, returning two arrays containing score and date to be displayed on the Stats page
func searchEntries(searchDays : String, searchBGNoise : String, searchSound : String, searchExercise : String):
	db.open_db() 
	var Query : String = "SELECT * FROM (SELECT * FROM Entries ORDER BY Date Desc) AS SortedEntries "
	
	if (searchDays == "All" && searchBGNoise == "All" && searchSound == "All" && searchExercise == "All"):
		db.query("SELECT DATE(Date) AS Day, AVG(Score) AS AverageScore FROM (" + Query + ") AS FilteredEntries GROUP BY DATE(Date);")
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
		AND (Exercise = COALESCE(" + filter[3] + ", Exercise))"
		print(Query)
		db.query("SELECT DATE(Date) AS Day, AVG(Score) AS AverageScore FROM (" + Query + ") AS FilteredEntries GROUP BY DATE(Date);")

	var queryResult = db.query_result
	db.close_db()
	var result := []
	for i in range(queryResult.size()): 
		var row := []
		result.append(row)
	for n in range (0, queryResult.size(), 1):
		result[0].append(queryResult[n]["Day"])
		result[1].append(int(queryResult[n]["AverageScore"]))
		
	return(result)	

#Randomly generates x amount of entries (testing purposes)
func addRandomEntry(num : int):
	var sounds = ["MvN", "TvP", "SvF"]
	var BGNoiseLevels = ["None", "Low", "Medium", "High"]
	db.open_db()
	for n in 100:
		var day : int = randi_range(1, 28)
		var hour : int = randi_range(1, 23)
		var minute : int = randi_range(1, 59)
		var second : int = randi_range(1, 59)
		var randomTime : String
		
		if (day < 10):
			randomTime = "'2024-02-0" + str(day) + " "
		else:
			randomTime = "'2024-02-" + str(day) + " "
			
		if (hour < 10):
			randomTime += "0" + str(hour) + ":"
		else:
			randomTime += str(hour) + ":"
			
		if (minute < 10):
			randomTime += "0" + str(minute) + ":"
		else:
			randomTime += str(minute) + ":"
			
		if (second < 10):
			randomTime += "0" + str(second) + "'"
		else:
			randomTime += str(second) + "'"
			
		var score : String = str(randi_range(1, 5000))
		var time : String = str(randi_range(1, 30))
		var bgNoise : String = BGNoiseLevels[randi_range(0, sounds.size() - 1)]
		var sound : String = sounds[randi_range(0, sounds.size() - 1)]
		var exercise : String = "Exercise " + str(randi_range(1, 2))
		
		db.query("INSERT INTO Entries (Date, Score, Time, BackgroundNoise, Sound, Exercise) VALUES ("
		+ randomTime + ", " + score + ", " + time + ", '" + bgNoise + "', '" + sound + "', '" + exercise + "');")
	db.query("SELECT * FROM Entries ORDER BY Date;")
	db.close_db()
	

