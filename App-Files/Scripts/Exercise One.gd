extends Node2D
# Declaring variables for the nodes
@onready var TTS = TextToSpeech
@onready var buttonOne = $Button/Button1
@onready var buttonTwo = $Button/Button2
@onready var buttonThree = $Button/Button3
@onready var buttonFour = $Button/Button4
@onready var starOne = $Node2D/Star1
@onready var starTwo = $Node2D/Star2
@onready var starThree = $Node2D/Star3
@onready var starFour = $Node2D/Star4
@onready var starFive = $Node2D/Star5
var numRounds
var maxNumRounds
var correctWord

# Called when the node enters the scene tree for the first time.
func _ready():
	numRounds = 1
	maxNumRounds = 5
	generateWords()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Functions tied to each button
func onButton1Pressed():
	checkCorrect(buttonOne.text, correctWord)

func onButton2Pressed():
	checkCorrect(buttonTwo.text, correctWord)

func onButton3Pressed():
	checkCorrect(buttonThree.text, correctWord)

func onButton4Pressed():
	checkCorrect(buttonFour.text, correctWord)

func onSoundButtonPressed():
	TTS.playText(correctWord)

# Load the next set of words
# Placeholder, this isn't implemented yet...
func generateWords():
	correctWord = "Cat"

# Game logic when user chooses a word
func checkCorrect(pressedWord, correctWord):
	#Word is correct
	if(pressedWord == correctWord):
		TTS.playText("Correct")
		changeNextStar(true, numRounds)
		nextRoundCheck()
	#Word is incorrect. The functionality here will likely be different.
	else:
		TTS.playText("Incorrect, the correct word was")
		TTS.playText(correctWord)
		changeNextStar(false, numRounds)
		nextRoundCheck()

# Visually changes the round indicator
func changeNextStar(correctIncorrect, numRounds):
	# Choosing starToBeChanged based off round
	var starToBeChanged
	match numRounds:
		1:
			starToBeChanged = starOne
		2:
			starToBeChanged = starTwo
		3:
			starToBeChanged = starThree
		4:
			starToBeChanged = starFour
		5:
			starToBeChanged = starFive
		_:
			TTS.playText("Something went wrong")
	
	# Changing based off of correct or incorrect answer
	if(correctIncorrect):
		starToBeChanged.texture = load("res://Artwork/starGreen.png")
	else:
		starToBeChanged.texture = load("res://Artwork/starRed.png")

# Checks number of rounds
func nextRoundCheck():
	#Continues the game if there are still rounds to be played
	if(numRounds < maxNumRounds):
			generateWords()
			numRounds += 1
	# Ends the game if there are no rounds left
	# Placeholder, this should reroute to different scene.
	else:
		TTS.playText("The game has ended, except not really because I haven't coded that yet")
