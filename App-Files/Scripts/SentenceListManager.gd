# SentenceListManager.gd
# This script reads in a csv file containing our sentence lists,
# and allows exercises to use specific word sound pairs in sentences and
# randomizes the words checking for duplicates

extends Node

# Structure to store sentence, learning word, and sound
struct SentencePair:
    var sentence: String
    var word: String
    var sound: String

# Dictionary to store paired sentences, words, and sounds
enum WordListType {
    CONSONANT,
    VOWEL
}

var consonantSentencePairs := []
var vowelSentencePairs := []
var usedConsonantSentences := []
var usedVowelSentences := []

func _ready():
    # Load the sentence pairs from the CSV files
    loadSentencePairs("res://consonant_sentence_list.csv", WordListType.CONSONANT)
    loadSentencePairs("res://vowel_sentence_list.csv", WordListType.VOWEL)

# Load the sentence pairs from a CSV file
func loadSentencePairs(filePath: String, type: WordListType) -> void:
    var file := File.new()
    file.open(filePath, File.READ)

    # Read each line from the CSV file
    while !file.eof_reached():
        var line := file.get_line().strip_edges()

        # Split each line into sentence, word, and sound
        var parts := line.split(",")

        if parts.size() == 3:
            var sentence := parts[0].strip_edges()
            var word := parts[1].strip_edges()
            var sound := parts[2].strip_edges()

            # Create a new SentencePair instance
            var pair = SentencePair(sentence, word, sound)

            # Add each sentence pair to the appropriate list
            if type == WordListType.CONSONANT:
                consonantSentencePairs.append(pair)
            elif type == WordListType.VOWEL:
                vowelSentencePairs.append(pair)

    file.close()

# Get a random sentence pair from the current sentence sound list
func getRandomSentencePair(type: WordListType, desiredSound: String) -> SentencePair:
    var sentencePairs, usedSentences: Array
    if type == WordListType.CONSONANT:
        sentencePairs = consonantSentencePairs
        usedSentences = usedConsonantSentences
    elif type == WordListType.VOWEL:
        sentencePairs = vowelSentencePairs
        usedSentences = usedVowelSentences
    else:
        print("Error: Unknown word list type.")
        return SentencePair("", "", "")

    if sentencePairs.size() == 0:
        print("Error: Current sentence list is empty.")
        return SentencePair("", "", "")

    # Filter sentence pairs based on the current list, matching sound, and exclude used sentences
    var filteredSentencePairs := []
    for pair in sentencePairs:
        if !usedSentences.has(pair) and pair.sound == desiredSound:
            filteredSentencePairs.append(pair)

    if filteredSentencePairs.size() == 0:
        usedSentences = []

    # Get a random sentence pair from the filtered list
    var randomIndex := randi() % filteredSentencePairs.size()
    var selectedPair := filteredSentencePairs[randomIndex]

    usedSentences.append(selectedPair)
    return selectedPair
