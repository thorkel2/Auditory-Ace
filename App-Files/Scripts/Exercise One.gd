extends Node2D
# Declaring variables for the nodes
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
@onready var roundTimer = $RoundTimer


# Other Variables used in code
var numRounds # Current number of rounds
var maxNumRounds # Maximum number of rounds
var correctWord # Current correct word
var nextBool = false # Next button is available or not
var soundIcon = preload('res://Icons/volume-2.svg') # Preload image

# Called when the node enters the scene tree for the first time.
func _ready():
	numRounds = 1
	maxNumRounds = 5
	
	# Next button starts disabled
	nextButton.set_disabled(true)
	
	# Start exercise
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
	TextToSpeech.playText(correctWord)

func onNextButtonPressed():
	# Goes to next round if available
	if(nextBool && nextButton.text != "Done"):
		generateWords()
		buttonColorChange(false)
		nextButton.set_disabled(true)
		nextBool = false
	else:
		gameDone()

func onExitButtonPressed():
	get_tree().change_scene_to_file("res://Scenes/pre_exercise_one_screen.tscn")

# Logic used by four word buttons
func buttonLogic(buttonNum):
	if(nextBool):
		# Plays word audio if user hasn't gone to next round yet
		TextToSpeech.playText(buttonNum.text)
	else:
		checkCorrect(buttonNum.text, correctWord)
		buttonColorChange(true)
		
		# Goes to next round or changes next button to be exit button
		if(numRounds != maxNumRounds):
			nextBool = true
			nextButton.set_disabled(false)
			numRounds += 1
		else:
			nextBool = true
			nextButton.set_disabled(false)
			nextButton.text = "Done"


# Generate next set of words and change buttons
func generateWords():
	# Using WordListManager.gd
	var wordSet = WordListManager.getRandomWordSet(WordListManager.chosenWordList)
	correctWord = wordSet.correctWord
	
	# Playing text for user
	TextToSpeech.playText(correctWord)
	
	# Changing text on buttons randomly
	var randomIndex = (randi() % 4) + 1
	var buttons = [buttonOne, buttonTwo, buttonThree, buttonFour]
	var j = 0
	for i in range(1,5):
		if(randomIndex == i):
			buttons[i-1].text = wordSet.correctWord
		else:
			buttons[i-1].text = wordSet.similarWords[j]
			j += 1

# Checks answer
func checkCorrect(pressedWord, correctWord):
	if(pressedWord == correctWord):
		Audio.playFX('correct')
		changeNextStar(true, numRounds)
	else:
		Audio.playFX('incorrect')
		changeNextStar(false, numRounds)

# Visually changes the round indicator
func changeNextStar(correctIncorrect, numRounds):
	# Choosing starToBeChanged based off round
	var stars = [starOne, starTwo, starThree, starFour, starFive]
	if(correctIncorrect):
		stars[numRounds-1].texture = load("res://Artwork/starGreen.png")
	else:
		stars[numRounds-1].texture = load("res://Artwork/starRed.png")

# Function to change colors of buttons
func buttonColorChange(colorBool: bool):
	var buttonArray = [buttonOne, buttonTwo, buttonThree, buttonFour]
	# Iterate through each button
	if(colorBool):
		for button in buttonArray:
			button.set_button_icon(soundIcon)
			if(button.text == correctWord):
				button.add_theme_color_override("font_color", Color('Dark_Green'))
				button.add_theme_color_override("font_hover_color", Color('Dark_Green'))
				button.add_theme_color_override("font_pressed_color", Color('Dark_Green'))
				button.add_theme_color_override("font_focus_color", Color('Dark_Green'))
				button.add_theme_color_override("font_hover_pressed_color", Color('Dark_Green'))
			else:
				button.add_theme_color_override("font_color", Color('Indian_Red'))
				button.add_theme_color_override("font_hover_color", Color('Indian_Red'))
				button.add_theme_color_override("font_pressed_color", Color('Indian_Red'))
				button.add_theme_color_override("font_focus_color", Color('Indian_Red'))
				button.add_theme_color_override("font_hover_pressed_color", Color('Indian_Red'))
	else:
		for button in buttonArray:
			button.set_button_icon(null)
			button.add_theme_color_override("font_color", Color('Black'))
			button.add_theme_color_override("font_hover_color", Color('Black'))
			button.add_theme_color_override("font_pressed_color", Color('Black'))
			button.add_theme_color_override("font_focus_color", Color('Black'))
			button.add_theme_color_override("font_hover_pressed_color", Color('Black'))


# Function to finish the game and send statistics info
#Not Fully implemented yet.
func gameDone():
	# This database entry is garbage. WIP
	Database.addEntry(1, round(4096 - roundTimer.time_left),'Low','MVN','Exercise 1')
	get_tree().change_scene_to_file("res://Scenes/post_exercise_screen.tscn")
