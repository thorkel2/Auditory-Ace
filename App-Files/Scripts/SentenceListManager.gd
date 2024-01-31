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

var consonantWordList := []
var vowelWordList := []
var usedConsonantWords := []
var usedVowelWords := []

func _ready():
    # Load the word lists from the CSV files
    loadWordList("res://consonant_sentence_list.csv", WordListType.CONSONANT)
    loadWordList("res://vowel_sentence_list.csv", WordListType.VOWEL)

# Load the sentence pairs from a CSV file
func loadWordList(filePath: String, type: WordListType) -> void:
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

            # Add each sentence pair to the appropriate list
            if type == WordListType.CONSONANT:
                consonantWordList.append(SentencePair(sentence: sentence, word: word, sound: sound))
            elif type == WordListType.VOWEL:
                vowelWordList.append(SentencePair(sentence: sentence, word: word, sound: sound))

    file.close()

# Get a random sentence pair from the current sentence sound list
func getRandomSentencePair(type: WordListType, desiredSound: String) -> SentencePair:
    var wordList, usedWords: Array
    if type == WordListType.CONSONANT:
        wordList = consonantWordList
        usedWords = usedConsonantWords
    elif type == WordListType.VOWEL:
        wordList = vowelWordList
        usedWords = usedVowelWords
    else:
        print("Error: Unknown word list type.")
        return SentencePair("", "", "")

    if wordList.size() == 0:
        print("Error: Current word list is empty.")
        return SentencePair("", "", "")

    # Filter sentences based on the current list, matching sound, and exclude used sentences
    var filteredSentences := []
    for pair in wordList:
        if !usedWords.has(pair) and pair.sound == desiredSound:
            filteredSentences.append(pair)

    if filteredSentences.size() == 0:
        usedWords = []

    # Get a random sentence pair from the filtered list
    var randomIndex := randi() % filteredSentences.size()
    var selectedPair := filteredSentences[randomIndex]

    usedWords.append(selectedPair)
    return selectedPair
