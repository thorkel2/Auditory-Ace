# SentenceListManager.gd
# This script reads in a CSV file containing our sentence lists,
# and allows exercises to use specific word sound pairs in sentences and
# randomizes the words checking for duplicates

extends Node

# Class to store sentence and word type
class SentencePair:
	var sentence: String
	var wordType: String

	# Constructor

	func _init(sentence_arg: String, wordType_arg: String):
		sentence = sentence_arg
		wordType = wordType_arg

# Dictionary to store paired sentences and word types
enum WordListType {
	NOUN,
	ADJ,
	PLACE,
 	FOOD,
	VERB
}

var nounSentencePairs: Array = []
var adjSentencePairs: Array = []
var placeSentencePairs: Array = []
var foodSentencePairs: Array = []
var verbSentencePairs: Array = []

var usedNounSentences: Array = []
var usedAdjSentences: Array = []
var usedPlaceSentences: Array = []
var usedFoodSentences: Array = []
var usedVerbSentences: Array = []

func _ready():
	# Load the sentence pairs from the CSV file
	loadSentencePairs("res://Word-Lists/Sentence Frames.csv")

# Load the sentence pairs from a CSV file
func loadSentencePairs(filePath: String) -> void:
	var file = FileAccess.open(filePath, FileAccess.READ)

	if file == null:
		print("Error: Failed to open file at", filePath)
		return
		
	# Read each line from the CSV file
	while !file.eof_reached():
		var line = file.get_line().strip_edges()

		# Split each line into sentence and word type
		var parts = line.split(",")

		if parts.size() == 2:
			var sentence = parts[0].strip_edges()
			var wordType = parts[1].strip_edges()

			# Create a new SentencePair instance
			var pair = SentencePair.new(sentence, wordType)

			# Add each sentence pair to the appropriate list
			match wordType:
				"Noun":
					nounSentencePairs.append(pair)
				"Adjective":
					adjSentencePairs.append(pair)
				"Verb":
					verbSentencePairs.append(pair)
				"Place":
					placeSentencePairs.append(pair)
				"Food":
					foodSentencePairs.append(pair)
				# Add more cases for other word types as needed

	file.close()

# Get a random sentence pair with the specified word type
func getRandomSentencePair(wordType: String) -> SentencePair:
	var sentencePairs: Array
	var usedSentences: Array

	# Select the appropriate sentence pairs list based on the word type
	match wordType:
		"Noun":
			sentencePairs = nounSentencePairs
			usedSentences = usedNounSentences
		"Adjective":
			sentencePairs = adjSentencePairs
			usedSentences = usedAdjSentences
		"Verb":
			sentencePairs = verbSentencePairs
			usedSentences = usedVerbSentences
		"Place":
			sentencePairs = placeSentencePairs
			usedSentences = usedPlaceSentences
		"Food":
			sentencePairs = foodSentencePairs
			usedSentences = usedFoodSentences
		# Add more cases for other word types as needed
		_:
			print("Error: Unknown word type.")
			return null

	# Check if the selected sentence pairs list is empty
	if sentencePairs.size() == 0:
		print("Error: Current sentence list is empty.")
		return null

	# Filter sentence pairs based on the current list and exclude used sentences
	var filteredSentencePairs: Array = []
	for pair in sentencePairs:
		if !usedSentences.has(pair):
			filteredSentencePairs.append(pair)

	# Reset used sentences list if all sentences have been used
	if filteredSentencePairs.size() == 0:
		usedSentences = []

	# Get a random sentence pair from the filtered list
	var randomIndex = randi() % filteredSentencePairs.size()
	var selectedPair = filteredSentencePairs[randomIndex]
	usedSentences.append(selectedPair)
	return selectedPair
