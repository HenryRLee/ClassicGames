extends CanvasLayer

signal restart

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

func _on_Board_win():
	$ScoreTimer.stop()
	$RestartButton.show()
	$Message.show()
	$Message.text = "Your score is " + str(score)
	var highScore = loadHighScore()
	if score < highScore:
		saveHighScore(score)
		$Message.text += "\nNew highscore!"
	else:
		$Message.text += "\nThe highscore is " + str(highScore)

func saveHighScore(highScore):
	var file = File.new()
	file.open("user://high_score.dat", File.WRITE)
	file.store_string(str(highScore))
	file.close()

func loadHighScore():
	var file = File.new()
	file.open("user://high_score.dat", File.READ)
	var content = file.get_as_text()
	file.close()
	if content:
		return int(content)
	else:
		return 0

func restart():
	startTimer()
	$Message.hide()
	$RestartButton.hide()
	emit_signal("restart")

func _on_RestartButton_pressed():
	restart()

func _on_RestartButtonSmall_pressed():
	restart()
