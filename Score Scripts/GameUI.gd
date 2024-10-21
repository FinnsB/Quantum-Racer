extends Control
##This is the score variable for the game which sets the score to 0 when the game starts##
var Score = 0
@onready var ScoreLabel = $Score

#This function tells godot the game has started#
func _ready():
	pass 

#This function runs every frame of the game, using the label score it increases the score by 0.1 every time it runs, and the final part updates the score on screen#
func _process(delta):
	Score += .1
	ScoreLabel.text = "Score: %d" % Score 
