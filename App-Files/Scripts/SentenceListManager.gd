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
    func _init(sentence: String, wordType: String):
        self.sentence = sentence
        self.wordType = wordType

# Dictionary to store paired sentences and word types
enum WordListType {
    NOUN,
    ADJ,
    VERB
}

var nounSentencePairs: Array = []
var adjSentencePairs: Array = []
var verbSentencePairs: Array = []
var usedNounSentences: Array = []
var usedAdjSentences: Array = []
var usedVerbSentences: Array = []

func _ready():
    # Load the sentence pairs from the CSV files
    loadSentencePairs("res://Word-Lists/noun_sentence_list.csv")
    loadSentencePairs("res://Word-Lists/adj_sentence_list.csv")
    loadSentencePairs("res://Word-Lists/verb_sentence_list.csv")

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
            var pair = SentencePair.new(sentence, wordType) # Corrected

            # Add each sentence pair to the appropriate list
            match wordType:
                "NOUN":
                    nounSentencePairs.append(pair)
                "ADJ":
                    adjSentencePairs.append(pair)
                "VERB":
                    verbSentencePairs.append(pair)
                # Add more cases for other word types as needed

    file.close()

# Get a random sentence pair from the current sentence list
func getRandomSentencePair(type: WordListType) -> SentencePair:
    var sentencePairs: Array
    var usedSentences: Array
    
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
        return SentencePair.new("", "")  # Corrected

    if sentencePairs.size() == 0:
        print("Error: Current sentence list is empty.")
        return SentencePair.new("", "")  # Corrected

    # Filter sentence pairs based on the current list and exclude used sentences
    var filteredSentencePairs: Array = []
    for pair in sentencePairs:
        if !usedSentences.has(pair):
            filteredSentencePairs.append(pair)

    if filteredSentencePairs.size() == 0:
        usedSentences = []

    # Get a random sentence pair from the filtered list
    var randomIndex = randi() % filteredSentencePairs.size()
    var selectedPair = filteredSentencePairs[randomIndex]

    usedSentences.append(selectedPair)
    return selectedPair
