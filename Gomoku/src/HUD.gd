extends Node2D

signal chooseSide(color, side)
signal startGame
signal stopGame
signal newGame

const BLACK = 1
const WHITE = -1
const HUMAN = 1
const COMPUTER = -1

func _ready():
	pass

func _on_BlackHuman_pressed():
	$Control.get_node("BlackHuman").get_node("Piece").show()
	$Control.get_node("BlackComputer").get_node("Piece").hide()
	emit_signal("chooseSide", BLACK, HUMAN)

func _on_WhiteHuman_pressed():
	$Control.get_node("WhiteHuman").get_node("Piece").show()
	$Control.get_node("WhiteComputer").get_node("Piece").hide()
	emit_signal("chooseSide", WHITE, HUMAN)

func _on_BlackComputer_pressed():
	$Control.get_node("BlackComputer").get_node("Piece").show()
	$Control.get_node("BlackHuman").get_node("Piece").hide()
	emit_signal("chooseSide", BLACK, COMPUTER)

func _on_WhiteComputer_pressed():
	$Control.get_node("WhiteComputer").get_node("Piece").show()
	$Control.get_node("WhiteHuman").get_node("Piece").hide()
	emit_signal("chooseSide", WHITE, COMPUTER)

func _on_StartButton_pressed():
	$Control.get_node("StartButton").hide()
	$Control.get_node("StopButton").show()
	emit_signal("startGame")

func _on_StopButton_pressed():
	$Control.get_node("StopButton").hide()
	$Control.get_node("StartButton").show()
	emit_signal("stopGame")

func _on_NewGame_pressed():
	#$Control.get_node("StopButton").hide()
	#$Control.get_node("StartButton").show()
	$Message.hide()
	emit_signal("newGame")

func _on_Board_win(side):
	if side == BLACK:
		$Message.text = "Black wins!"
	else:
		$Message.text = "White wins!"
	$Message.show()
