extends Node2D

onready var Piece = preload("res://Piece.tscn")
onready var Player = preload("res://Player.tscn")
onready var AI = preload("res://AI.tscn")

signal win(color)

var grid = []

const n = 15
const size = 32
const BLACK = 1
const WHITE = -1
const HUMAN = 1
const COMPUTER = -1

var turn = BLACK
var participants = {}
var sides = []

func _ready():
	init()

func init():
	for i in range(n):
		var row = []
		for j in range(n):
			row.append(0)
		grid.append(row)

func start():
	createParticipant(BLACK, sides[0])
	createParticipant(WHITE, sides[1])

func stop():
	for key in participants:
		if is_instance_valid(participants[key]):
			participants[key].queue_free()

func setSides(black, white):
	sides = [black, white]

func createParticipant(color, side):
	if side == HUMAN:
		participants[color] = Player.instance()
	else:
		participants[color] = AI.instance()
	participants[color].setColor(color)
	if color == BLACK:
		participants[color].connect("setPiece", self, "setBlackPiece")
	else:
		participants[color].connect("setPiece", self, "setWhitePiece")
	add_child(participants[color])

	if participants[color].has_method("action"):
		participants[color].action(Array(grid))

func setBlackPiece(position):
	setPiece(position, BLACK)

func setWhitePiece(position):
	setPiece(position, WHITE)

func setPiece(position, color):
	if turn != color: return
	var x = position.x
	var y = position.y
	if grid[x][y] == 0:
		grid[x][y] = color

		var piece = Piece.instance()
		piece.setColor(grid[x][y])
		piece.translate(Vector2(x * size, y * size))
		add_child(piece)

		if checkEndgame():
			yield(get_tree().create_timer(0.2), "timeout")
			emit_signal("win", color)
			stop()
			return

		turn = -color
		if participants[turn].has_method("action"):
			participants[turn].action(Array(grid))

func checkEndgame():
	var directions = [Vector2(-1, 0), Vector2(0, -1), Vector2(-1, -1), Vector2(-1, 1)]
	for direction in directions:
		var dp = []
		for i in range(n):
			var row = []
			for j in range(n):
				row.append(0)
			dp.append(row)
		var di = direction.x
		var dj = direction.y
		for i in range(n):
			for j in range(n):
				if grid[i][j] == 0: continue
				if i + di >= n || i + di < 0: continue
				if j + dj >= n || j + dj < 0: continue
				if grid[i][j] == grid[i+di][j+dj]:
					dp[i][j] = dp[i+di][j+dj] + 1
					if dp[i][j] == 4: return true
	return false
