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
@onready var topText = $Background/ColorRect/TopText
@onready var selectedIndicator = $SelectedIndicator

# Other Variables used in code
var numRounds # Current number of rounds
var maxNumRounds # Maximum number of rounds
var correctWord # Current correct word
var replayMode: bool # Boolean for game being in replay mode
var soundIcon = preload('res://Icons/volume-2.svg') # Preload image
var numCorrect = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	numRounds = 1
	maxNumRounds = 5
	# Reset
	WordListManager.score = 0
	WordListManager.initialTime = 0
	WordListManager.finalTime = 0
	# Start exercise
	nextButton.set_disabled(true)
	replayMode = false
	generateWords()
	selectedIndicator.set_visible(false)
	
	# BG Noise
	Audio.playBGNoise()

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
	if(nextButton.text == "Done"):
		gameDone()
	else:
		replayMode = false
		buttonColorChange(false)
		selectedIndicator.set_visible(false)
		generateWords()
		nextButton.set_disabled(true)
		topText.text = "Tap to hear again"

func onExitButtonPressed():
	Audio.stopBGNoise()
	get_tree().change_scene_to_file("res://Scenes/pre_exercise_one_screen.tscn")

# Logic used by four word buttons
func buttonLogic(buttonNum):
	# If game is in replay mode just play text and end function
	if(replayMode):
		TextToSpeech.playText(buttonNum.text)
		return
	
	var correct: bool = checkCorrect(buttonNum.text, correctWord)
	var roundAvailable: bool = (numRounds != maxNumRounds)
	
	if (correct && roundAvailable):
		numRounds += 1
		onNextButtonPressed()
	elif (!correct && roundAvailable):
		numRounds += 1
		replayMode = true
		nextButton.set_disabled(true)
		buttonColorChange(true)
		selectedIndicator.set_position(buttonNum.get_position())
		selectedIndicator.set_visible(true)
		topText.text = "Tap words to practice"
	elif (correct && !roundAvailable):
		# Short pause before game end
		await get_tree().create_timer(1.0).timeout
		gameDone()
	elif (!correct && !roundAvailable):
		replayMode = true
		nextButton.set_disabled(true)
		buttonColorChange(true)
		selectedIndicator.set_position(buttonNum.get_position())
		selectedIndicator.set_visible(true)
		topText.text = "Tap words to practice"
		nextButton.text = "Done"
	else:
		print("Error")
	
	# Enter replay mode if incorrect
	if(!correct):
		replayMode = true
		nextButton.set_disabled(false)

# Generate next set of words and change buttons
func generateWords():
	# Using WordListManager.gd
	var wordSet = WordListManager.getRandomWordSet(WordListManager.chosenWordList)
	correctWord = wordSet.correctWord
	
	# Start time tracking
	WordListManager.initialTime = Time.get_ticks_msec()
	
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

# Checks answer, plays audio, changes indicator
func checkCorrect(pressedWord, correctWord) -> bool:
	if(pressedWord == correctWord):
		WordListManager.calculateTimeScore(true)
		numCorrect += 1
		Audio.playFX('correct')
		changeNextStar(true, numRounds)
		return true
	else:
		WordListManager.calculateTimeScore(false)
		Audio.playFX('incorrect')
		changeNextStar(false, numRounds)
		return false

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
func gameDone():
	Audio.stopBGNoise()
	
	# Converting chosenWordList value to usable string for database
	var wordListEntry
	match str(WordListManager.chosenWordList):
		'0':
			wordListEntry = 'MvN'
		'1':
			wordListEntry = 'SvF'
		'2':
			wordListEntry = 'TvP'
	
	# Database entry
	Database.addEntry(WordListManager.score, WordListManager.finalTime, WordListManager.bgLevel, wordListEntry, 'Exercise 1')
	
	# Move to post game
	get_tree().change_scene_to_file("res://Scenes/post_exercise_screen.tscn")
