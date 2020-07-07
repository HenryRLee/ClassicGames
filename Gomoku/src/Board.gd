extends Node2D

onready var Game = preload("res://Game.tscn")

signal win(side)

const n = 15
const size = 32
const BLACK = 1
const WHITE = -1
const HUMAN = 1
const COMPUTER = -1
var game
var sides = [HUMAN, COMPUTER]

func _ready():
	pass

func _draw():
	for i in range(n):
		draw_line(Vector2(0, i * size), Vector2((n - 1) * size, i * size), Color.black)
		draw_line(Vector2(i * size, 0), Vector2(i * size, (n - 1) * size), Color.black)

	draw_circle(Vector2(n / 2 * size, n / 2 * size), 3, Color.black)
	draw_circle(Vector2(3 * size, 3 * size), 3, Color.black)
	draw_circle(Vector2(3 * size, 11 * size), 3, Color.black)
	draw_circle(Vector2(11 * size, 3 * size), 3, Color.black)
	draw_circle(Vector2(11 * size, 11 * size), 3, Color.black)

func newGame():
	if game:
		game.queue_free()
	game = Game.instance()
	game.connect("win", self, "win")
	game.setSides(sides[0], sides[1])
	add_child(game)
	game.start()

func win(color):
	emit_signal("win", color)

func _on_HUD_chooseSide(color, side):
	if color == BLACK:
		sides[0] = side
	else:
		sides[1] = side

func _on_HUD_startGame():
	game.start()

func _on_HUD_stopGame():
	game.stop()

func _on_HUD_newGame():
	newGame()
