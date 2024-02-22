# SentenceListManager.gd
# This script reads in a CSV file containing our sentence lists,
# and allows exercises to use specific word sound pairs in sentences and
# randomizes the words checking for duplicates

extends Node

# Structure to store sentence and word type
struct SentencePair:
    var sentence: String
    var wordType: String

# Dictionary to store paired sentences and word types
enum WordListType {
    NOUN,
    ADJ,
    VERB
}

var nounSentencePairs := []
var adjSentencePairs := []
var verbSentencePairs := []
var usedNounSentences := []
var usedAdjSentences := []
var usedVerbSentences := []

func _ready():
    # Load the sentence pairs from the CSV files
    loadSentencePairs("res://Word-Lists/noun sentence list.csv", WordListType.NOUN)
    loadSentencePairs("res://Word-Lists/adj sentence list.csv", WordListType.ADJ)
    loadSentencePairs("res://Word-Lists/verb sentence list.csv", WordListType.VERB)

# Load the sentence pairs from a CSV file
func loadSentencePairs(filePath: String, type: WordListType) -> void:
    var file = FileAccess.open(filePath, FileAccess.READ)

    if file == null:
        print("Error: Failed to open file at", filePath)
        return
        
    # Read each line from the CSV file
    while !file.eof_reached():
        var line := file.get_line().strip_edges()

        # Split each line into sentence and word type
        var parts := line.split(",")

        if parts.size() == 2:
            var sentence := parts[0].strip_edges()
            var wordType := parts[1].strip_edges()

            # Create a new SentencePair instance
            var pair = SentencePair(sentence, wordType)

            # Add each sentence pair to the appropriate list
            match type:
                WordListType.NOUN:
                    nounSentencePairs.append(pair)
                WordListType.ADJ:
                    adjSentencePairs.append(pair)
                WordListType.VERB:
                    verbSentencePairs.append(pair)

    file.close()

# Get a random sentence pair from the current sentence list
func getRandomSentencePair(type: WordListType) -> SentencePair:
    var sentencePairs, usedSentences: Array
    if type == WordListType.NOUN:
        sentencePairs = nounSentencePairs
        usedSentences = usedNounSentences
    elif type == WordListType.ADJ:
        sentencePairs = adjSentencePairs
        usedSentences = usedAdjSentences
    elif type == WordListType.VERB:
        sentencePairs = verbSentencePairs
        usedSentences = usedVerbSentences
    else:
        print("Error: Unknown word list type.")
        return SentencePair("", "")

    if sentencePairs.size() == 0:
        print("Error: Current sentence list is empty.")
        return SentencePair("", "")

    # Filter sentence pairs based on the current list and exclude used sentences
    var filteredSentencePairs := []
    for pair in sentencePairs:
        if !usedSentences.has(pair):
            filteredSentencePairs.append(pair)

    if filteredSentencePairs.size() == 0:
        usedSentences = []

    # Get a random sentence pair from the filtered list
    var randomIndex := randi() % filteredSentencePairs.size()
    var selectedPair := filteredSentencePairs[randomIndex]

    usedSentences.append(selectedPair)
    return selectedPair
