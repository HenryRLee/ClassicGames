extends CanvasLayer

var score = 0

func _ready():
	startTimer()
	pass

func startTimer():
	score = 0
	updateScore()
	$ScoreTimer.start()

func updateScore():
	$ScoreLabel.text = str(score)

func _on_ScoreTimer_timeout():
	score += 1
	updateScore()
