extends Node2D

const BLACK = 1
const WHITE = -1

func _ready():
	pass

func setColor(c):
	if c == WHITE:
		useWhite()
	elif c == BLACK:
		useBlack()

func useWhite():
	$White.show()
	$Black.hide()

func useBlack():
	$Black.show()
	$White.hide()
