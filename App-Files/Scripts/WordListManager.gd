# WordListManager.gd
# This script reads in a csv file containing our word lists, 
# and allows exercises to use specific word sound pairs and 
# randomizes the words checking for duplicates

extends Node

# Dictionary to store paired words and sounds
var wordPairs := {}
var currentWordSoundList := []
var usedWordSoundPairs := []

func _ready():
    # Load the word pairs from the CSV file (or any other data source)
    loadWordPairs("res://word_pairs.csv") #This will reply on Sienna's word csv file

# Load the word pairs from a CSV file
func loadWordPairs(filePath: String) -> void:
    var file := File.new()
    file.open(filePath, File.READ)

    # Read each line from the CSV file
    while !file.eof_reached():
        var line := file.get_line().strip_edges()

        # Split each line into word and sound
        var parts := line.split(",")
        if parts.size() == 2:
            wordPairs[parts[0].to_lower()] = parts[1].to_lower()

    file.close()

# Set the current word sound list
# This way we can seperate the word sound lists for each exercise
func setWordSoundList(soundList: Array) -> void:
    currentWordSoundList = soundList
    usedWordSoundPairs = []

# Get a random word pair from the current word sound list
# Helps randomize the word pairs (may be deleted if each exercise wants to do this themselves)
func getRandomWordPair() -> Dictionary:
    if currentWordSoundList.size() == 0:
        print("Error: Current word sound list is empty.")
        return {}

    # Filter word pairs based on the current sound list and exclude used word-sound pairs
    var filteredPairs := {}
    for word in currentWordSoundList:
        var wordSoundPair := {"word": word, "sound": wordPairs[word].to_lower()}

        if !usedWordSoundPairs.has(wordSoundPair):
            filteredPairs[word] = wordSoundPair

    # If all word-sound pairs have been used, reset the used pairs list
    if filteredPairs.size() == 0:
        usedWordSoundPairs = []

    # Get a random word pair from the filtered list
    var keys := filteredPairs.keys()
    var randomKey := keys[randi() % keys.size()]

    # Mark the word-sound pair as used
    usedWordSoundPairs.append(filteredPairs[randomKey])

    return filteredPairs[randomKey]

# Check if the provided word matches the sound
func isMatch(word: String, sound: String) -> bool:
    return wordPairs[word.to_lower()] == sound.to_lower()
