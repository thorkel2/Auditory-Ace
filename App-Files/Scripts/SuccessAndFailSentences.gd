# SuccessFailureSentences.gd
# This script provides random success and failure sentences to add after the end of an exercise.

extends Node

# List of success sentences
var successSentences := [
    "Congratulations! You did it!",
    "Great job! You nailed it!",
    "Awesome work! Keep it up!",
    "Well done! You're making progress!",
    "Fantastic! You're getting better!",
    "Superb! You're on fire!",
    "Impressive! You're mastering this!",
    "Bravo! You're crushing it!",
    "Excellent! You're unstoppable!",
    "Outstanding! You're a star!"
]

# List of failure sentences
var failureSentences := [
    "Mistakes happen! Keep trying!",
    "Every setback is a setup for a comeback!",
    "Progress comes from persistence!",
    "Keep going! You're closer than you think!",
    "Don't let this discourage you! You're improving!",
    "Learning is a journey, not a destination!",
    "Stay positive! You're making strides!",
    "Your effort is what counts! Keep pushing!",
    "You're learning with every attempt! Keep it up!",
    "Persistence is key! You'll get there!"
]

# Get a random success sentence
func getRandomSuccessSentence() -> String:
    var randomIndex := randi() % successSentences.size()
    return successSentences[randomIndex]

# Get a random failure sentence
func getRandomFailureSentence() -> String:
    var randomIndex := randi() % failureSentences.size()
    return failureSentences[randomIndex]