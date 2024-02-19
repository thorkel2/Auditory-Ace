# WordListManager.gd

extends Node

# Enumerated type to represent different word list types
enum WordListType {
	MVN,  # M vs N word types
	SVF,  # S vs F word types
	TVP   # T vs P word types
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
var mVnWordSets := []
var sVfWordSets := []
var tVpWordSets := []
var usedmVnWords := []
var usedsVfWords := []
var usedtVpWords := []

# Initialization function called when the Node enters the scene tree
func _ready():
	# Load the word sets from the CSV files
	loadWordSets("res://m_vs_n.csv", WordListType.MVN) # M vs N word types
	loadWordSets("res://s_vs_f.csv", WordListType.SVF) # S vs F word types
	loadWordSets("res://t_vs_p.csv", WordListType.TVP) # T vs P word types

# Load the word sets from a CSV file and add them to the appropriate list
func loadWordSets(filePath: String, type: WordListType) -> void:
	var file := File.new()
	file.open(filePath, File.READ)

	# Read each line from the CSV file
	while !file.eof_reached():
		var line := file.get_line().strip_edges()

		# Split each line into word set components
		var parts := line.split(",")

		# Ensure the line contains enough components to create a word set
		if parts.size() >= 6:
			var correctWord := parts[0].strip_edges()
			var similarWords := [parts[1].strip_edges(), parts[2].strip_edges(), parts[3].strip_edges()]
			var wordType := parts[4].strip_edges()
			var sound := parts[5].strip_edges()

			# Create a new WordSet instance
			var wordSet = WordSet.new(correctWord, similarWords, wordType, sound)

			# Add the word set to the appropriate list based on the word list type
			if type == WordListType.MVN:
				mVnWordSets.append(wordSet)
			elif type == WordListType.SVF:
				sVfWordSets.append(wordSet)
			elif type == WordListType.TVP:
				tVpWordSets.append(wordSet)

	file.close()

# Get a random word set from the current word sound list based on the desired sound type
func getRandomWordSet(type: WordListType, desiredSound: String) -> WordSet:
	var wordSets: Array
	var usedWords: Array
	if type == WordListType.MVN:
		wordSets = mVnWordSets
		usedWords = usedmVnWords
	elif type == WordListType.SVF:
		wordSets = sVfWordSets
		usedWords = usedsVfWords
	elif type == WordListType.TVP:
		wordSets = tVpWordSets
		usedWords = usedtVpWords
	else:
		print("Error: Unknown word list type.")
		return null
	
	if wordSets.size() == 0:
		print("Error: Current word list is empty.")
		return null
	
	# Filter word sets based on the desired sound type and exclude used words
	var filteredWordSets := []
	for wordSet in wordSets:
		if !usedWords.has(wordSet.correctWord) and wordSet.sound == desiredSound:
			filteredWordSets.append(wordSet)
	
	if filteredWordSets.size() == 0:
		usedWords = []
	
	# Get a random word set from the filtered list
	var randomIndex := randi() % filteredWordSets.size()
	var selectedWordSet := filteredWordSets[randomIndex]
	
	usedWords.append(selectedWordSet.correctWord)
	return selectedWordSet
