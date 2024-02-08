# WordListManager.gd
# This script reads in a csv file containing our word lists,
# and allows exercises to use specific word sound pairs and
# randomizes the words checking for duplicates

extends Node

# Dictionary to store paired words and sounds
<<<<<<< HEAD
enum WordListType {
    CONSONANT,
    VOWEL
=======
# to add a new type, simply add a comma after the last option,
# create a new line, and add in (all caps) the type of list
enum WordListType {
    MVN,
    SVF
>>>>>>> 4c1b34063da66ac638733fa4c5698570c2b3b2fc
}

# Data structure to represent a word set
class WordSet:
    var correctWord: String
    var similarWords: Array
    var wordType: String
    var sound: String

    func _init(correctWord, similarWords, wordType, sound):
        self.correctWord = correctWord
        self.similarWords = similarWords
        self.wordType = wordType
        self.sound = sound

<<<<<<< HEAD
var consonantWordSets := []
var vowelWordSets := []
var usedConsonantWords := []
var usedVowelWords := []

func _ready():
    # Load the word sets from the CSV files
    loadWordSets("res://consonant_word_sets.csv", WordListType.CONSONANT)
    loadWordSets("res://vowel_word_sets.csv", WordListType.VOWEL)
=======
var mVnWordSets := []
var sVfWordSets := []
var usedmVnWords := []
var usedsVfWords := []

func _ready():
    # Load the word sets from the CSV files
    loadWordSets("res://m vs n.csv", WordListType.MVN) # M vs N word types
    loadWordSets("res://s vs f.csv", WordListType.SVF) # S vs F word types
>>>>>>> 4c1b34063da66ac638733fa4c5698570c2b3b2fc

# Load the word sets from a CSV file
func loadWordSets(filePath: String, type: WordListType) -> void:
    var file := File.new()
    file.open(filePath, File.READ)

    # Read each line from the CSV file
    while !file.eof_reached():
        var line := file.get_line().strip_edges()

        # Split each line into word set components
        var parts := line.split(",")

        if parts.size() >= 6:
            var correctWord := parts[0].strip_edges()
            var similarWords := [parts[1].strip_edges(), parts[2].strip_edges(), parts[3].strip_edges()]
            var wordType := parts[4].strip_edges()
            var sound := parts[5].strip_edges()

            # Create a new WordSet instance
            var wordSet = WordSet.new(correctWord, similarWords, wordType, sound)

            # Add the word set to the appropriate list
<<<<<<< HEAD
            if type == WordListType.CONSONANT:
                consonantWordSets.append(wordSet)
            elif type == WordListType.VOWEL:
                vowelWordSets.append(wordSet)
=======
            if type == WordListType.MVN:
                mVnWordSets.append(wordSet)
            elif type == WordListType.SVF:
                sVfWordSets.append(wordSet)
>>>>>>> 4c1b34063da66ac638733fa4c5698570c2b3b2fc

    file.close()

# Get a random word set from the current word sound list
func getRandomWordSet(type: WordListType, desiredSound: String) -> WordSet:
    var wordSets, usedWords: Array
<<<<<<< HEAD
    if type == WordListType.CONSONANT:
        wordSets = consonantWordSets
        usedWords = usedConsonantWords
    elif type == WordListType.VOWEL:
        wordSets = vowelWordSets
        usedWords = usedVowelWords
=======
    if type == WordListType.MVN:
        wordSets = mVnWordSets
        usedWords = usedmVnWords
    elif type == WordListType.SVF:
        wordSets = sVfWordSets
        usedWords = usedsVfWords
>>>>>>> 4c1b34063da66ac638733fa4c5698570c2b3b2fc
    else:
        print("Error: Unknown word list type.")
        return null
    
    if wordSets.size() == 0:
        print("Error: Current word list is empty.")
        return null
    
    # Filter word sets based on the current list, matching sound, and exclude used words
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
