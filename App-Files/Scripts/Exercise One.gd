extends Node2D
@onready var TTS = TextToSpeech
@onready var buttonOne = $Button/Button1
@onready var buttonTwo = $Button/Button2
@onready var buttonThree = $Button/Button3
@onready var buttonFour = $Button/Button4
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

#Load the next set of words
#Placeholder, this isn't coded yet...
func generateWords():
	correctWord = "Cat"

#Game logic when user chooses a word
func checkCorrect(pressedWord, correctWord):
	#Word is correct
	if(pressedWord == correctWord):
		TTS.playText("Correct")
		nextRoundCheck()
	#Word is incorrect. The functionality here will likely be different.
	else:
		TTS.playText("Incorrect, the correct word was")
		TTS.playText(correctWord)
		nextRoundCheck()

#Checks number of rounds
func nextRoundCheck():
	#Continues the game if there are still rounds to be played
	if(numRounds < maxNumRounds):
			generateWords()
			numRounds += 1
	#Ends the game if there are not
	#Functionality will be different here
	else:
		TTS.playText("The game has ended, except not really because I haven't coded that yet")
