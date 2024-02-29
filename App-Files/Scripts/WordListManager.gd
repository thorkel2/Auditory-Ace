# WordListManager.gd
# This script reads in multiple CSV files containing our words lists,
# and allows exercises to use specific word sound pairs and
# randomizes the words checking for duplicates

extends Node

# Enumerated type to represent different word list types
enum WordListType {
	MVN,  # M vs N word types
	SVF,  # S vs F word types
	TVP,  # T vs P word types
	FOOD,  # Food word types 
	PLACE
}

# Data structure to represent a word set containing a correct word,
# similar words, word type, and associated sound
class WordSet:
	var correctWord: String
	var similarWords: Array
	var wordType: String
	var sound: String

	# Constructor
	func _init(correctWord, similarWords, wordType, sound):
		self.correctWord = correctWord
		self.similarWords = similarWords
		self.wordType = wordType
		self.sound = sound

# Lists to store word sets and used words for each word list type
var mVnWordSets = []
var sVfWordSets = []
var tVpWordSets = []
var foodWordSets = []
var placeWordSets = []

var usedmVnWords = []
var usedsVfWords = []
var usedtVpWords = []
var usedFoodWords = []
var usedPlaceWords = []

# Variables used as a global variables for exercise one
var chosenWordList: WordListType
var score = 0
var bgLevel = "None"
var initialTime = 0
var finalTime = 0
# Initialization function called when the Node enters the scene tree
func _ready():
	# Load the word sets from the CSV files
	loadWordSets("res://Word-Lists/m vs n.csv", WordListType.MVN) # M vs N word types
	loadWordSets("res://Word-Lists/s vs f.csv", WordListType.SVF) # S vs F word types
	loadWordSets("res://Word-Lists/t vs p.csv", WordListType.TVP) # T vs P word types
	loadWordSets("res//Word-Lists/Food.csv", WordListType.FOOD)   # Food word types
	loadWordSets("res//Word-Lists/Places.csv", WordListType.PLACE) # Place word types

# Load the word sets from a CSV file and add them to the appropriate list
func loadWordSets(filePath: String, type: WordListType) -> void:
	var file = FileAccess.open(filePath, FileAccess.READ)
	
	if file == null:
		print("Error: Failed to open file at", filePath)
		return

	# Read each line from the CSV file
	while !file.eof_reached():
		var line = file.get_line().strip_edges()

		# Split each line into word set components
		var parts = line.split(",")

		# Ensure the line contains enough components to create a word set
		if parts.size() >= 6:
			var similarWords = [parts[0].strip_edges(), parts[1].strip_edges(), parts[2].strip_edges(), parts[3].strip_edges()]
			var wordType = parts[4].strip_edges()
			var sound = parts[5].strip_edges()

			# Create a new WordSet instance
			var wordSet = WordSet.new("", similarWords, wordType, sound)

			# Add the word set to the appropriate list based on the word list type
			match type:
				WordListType.MVN:
					mVnWordSets.append(wordSet)
				WordListType.SVF:
					sVfWordSets.append(wordSet)
				WordListType.TVP:
					tVpWordSets.append(wordSet)
				WordListType.FOOD:
					foodWordSets.append(wordSet)
				WordListType.PLACE:
					placeWordSets.append(wordSet)

	file.close()

# Get a random word set from the current word sound list based on the desired sound type
func getRandomWordSet(type: WordListType) -> WordSet:
	var wordSets: Array
	var usedWords: Array
	match type:
		WordListType.MVN:
			wordSets = mVnWordSets
			usedWords = usedmVnWords
		WordListType.SVF:
			wordSets = sVfWordSets
			usedWords = usedsVfWords
		WordListType.TVP:
			wordSets = tVpWordSets
			usedWords = usedtVpWords
		WordListType.FOOD:
			wordSets = foodWordSets
			usedWords = usedFoodWords
		WordListType.PLACE:
			wordSets = placeWordSets
			usedWords = usedPlaceWords
		_:
			print("Error: Unknown word list type.")
			return null

	if wordSets.size() == 0:
		print("Error: Current word list is empty.")
		return null

	# Get a random word set from the list
	var randomIndex := randi() % wordSets.size()
	var selectedWordSet = wordSets[randomIndex] as WordSet

	# Randomly select one of the words from similarWords as the correct word
	var correctWordIndex = randi() % selectedWordSet.similarWords.size()
	selectedWordSet.correctWord = selectedWordSet.similarWords[correctWordIndex]

	# Add the selected word to the used words list
	usedWords.append(selectedWordSet.correctWord)

	return selectedWordSet

# Setter for chosenWordList
func setWordListVar(chosen: int):
	match chosen:
		1:
			chosenWordList = WordListType.MVN
		2:
			chosenWordList = WordListType.SVF
		3:
			chosenWordList = WordListType.TVP
		4:
			chosenWordList = WordListType.FOOD
		5:
			chosenWordList = WordListType.PLACE
			
func calculateTimeScore(correct : bool):
	var timeTaken = Time.get_ticks_msec() - initialTime
	if (correct):
		if timeTaken < 1500:
			score += 1000
		elif timeTaken < 27777:
			score += int(1000 - (6 * sqrt(timeTaken - 1500)))
	finalTime += timeTaken
	print("Time taken: " + str(timeTaken) + "ms Total time: " + str(finalTime) + "ms Score: " + str(score))
