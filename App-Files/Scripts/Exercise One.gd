extends Node2D
# Declaring variables for the nodes
@onready var TTS = TextToSpeech
@onready var buttonOne = $Button/Button1
@onready var buttonTwo = $Button/Button2
@onready var buttonThree = $Button/Button3
@onready var buttonFour = $Button/Button4
@onready var nextButton = $Button/NextButton
@onready var starOne = $Node2D/Star1
@onready var starTwo = $Node2D/Star2
@onready var starThree = $Node2D/Star3
@onready var starFour = $Node2D/Star4
@onready var starFive = $Node2D/Star5

# Other Variables used in code
var numRounds # Current number of rounds
var maxNumRounds # Maximum number of rounds
var correctWord # Current correct word
var nextBool = false # Next button is available or not

# Called when the node enters the scene tree for the first time.
func _ready():
	numRounds = 1
	maxNumRounds = 5
	# Next button starts off screen
	nextButton.set_position(Vector2(5000,5000))
	generateWords()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Functions tied to each button
func onButton1Pressed():
	buttonLogic(buttonOne)

func onButton2Pressed():
	buttonLogic(buttonTwo)

func onButton3Pressed():
	buttonLogic(buttonThree)

func onButton4Pressed():
	buttonLogic(buttonFour)

func onSoundButtonPressed():
	TTS.playText(correctWord)

func onNextButtonPressed():
	# Goes to next round if available
	if(nextBool && nextButton.text != "Done"):
		generateWords()
		nextButton.set_position(Vector2(5000,5000))
		nextBool = false
	else:
		# This should go to a post game scene. Will do this later
		TTS.playText("Game is done")

# Logic used by four word buttons
func buttonLogic(buttonNum):
	if(nextBool):
		# Just plays audio if user hasn't gone to next round yet.
		TTS.playText(buttonNum.text)
	else:
		checkCorrect(buttonNum.text, correctWord)
		# Goes to next round or changes next button to be exit button
		if(numRounds != maxNumRounds):
			nextBool = true
			nextButton.set_position(Vector2(569,150))
			numRounds += 1
		else:
			nextBool = true
			nextButton.set_position(Vector2(569,150))
			nextButton.text = "Done"


# Load the next set of words
# Placeholder, this isn't implemented yet...
func generateWords():
	correctWord = "Cat"

# Checks answer
func checkCorrect(pressedWord, correctWord):
	if(pressedWord == correctWord):
		TTS.playText("Correct")
		changeNextStar(true, numRounds)
	else:
		TTS.playText("Incorrect")
		changeNextStar(false, numRounds)

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
