extends Control

var Score = 0
@onready var ScoreLabel = $Score


func _ready():
	pass 


func _process(delta):
	Score += .1
	ScoreLabel.text = "Score: %d" % Score 
