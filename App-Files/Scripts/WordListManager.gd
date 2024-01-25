# WordListManager.gd
# This script reads in a csv file containing our word lists,
# and allows exercises to use specific word sound pairs and
# randomizes the words checking for duplicates

extends Node

# Dictionary to store paired words and sounds
enum WordListType {
    CONSONANT,
    VOWEL
}

var consonantWordList := []
var vowelWordList := []
var usedConsonantWords := []
var usedVowelWords := []

func _ready():
    # Load the word lists from the CSV files
    loadWordList("res://consonant_word_list.csv", WordListType.CONSONANT)
    loadWordList("res://vowel_word_list.csv", WordListType.VOWEL)

# Load the word pairs from a CSV file
func loadWordList(filePath: String, type: WordListType) -> void:
    var file := File.new()
    file.open(filePath, File.READ)

    # Read each line from the CSV file
    while !file.eof_reached():
        var line := file.get_line().strip_edges()

        # Add each line (word) to the appropriate word list
        if type == WordListType.CONSONANT:
            consonantWordList.append(line.to_lower())
        elif type == WordListType.VOWEL:
            vowelWordList.append(line.to_lower())

    file.close()

# Get a random word pair from the current word sound list
# Helps randomize the word pairs (may be deleted if each exercise wants to do this themselves)
func getRandomWordPair(type: WordListType) -> String:
    var wordList, usedWords: Array
    if type == WordListType.CONSONANT:
        wordList = consonantWordList
        usedWords = usedConsonantWords
    elif type == WordListType.VOWEL:
        wordList = vowelWordList
        usedWords = usedVowelWords
    else:
        print("Error: Unknown word list type.")
        return ""

    if wordList.size() == 0:
        print("Error: Current word list is empty.")
        return ""

    # Filter words based on the current list and exclude used words
    var filteredWords := []
    for word in wordList:
        if !usedWords.has(word):
            filteredWords.append(word)

    # If all words have been used, reset the used words list
    if filteredWords.size() == 0:
        usedWords = []

    # Get a random word from the filtered list
    var randomIndex := randi() % filteredWords.size()
    var selectedWord := filteredWords[randomIndex]

    # Mark the word as used
    usedWords.append(selectedWord)

    return selectedWord
