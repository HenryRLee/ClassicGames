extends Node2D

signal setPiece(position)

const n = 15

const WINNING = 1
const LOSING = 0
const UNCLEAR = -1

const BLACK = 1
const WHITE = -1

var color_

func _ready():
	randomize()

func setColor(color):
	color_ = color

func action(grid):
	var bestScore = -2000
	var bestMove

	for m in getNeighbors(grid):
		var i = m.x
		var j = m.y
		if grid[i][j] == 0:
			grid[i][j] = color_
			var score = checkMove(grid, Vector2(i, j))
			grid[i][j] = 0
			if score > bestScore:
				bestScore = score
				bestMove = Vector2(i, j)
			if score == bestScore && randi() % 2 == 0:
				bestMove = Vector2(i, j)
	yield(get_tree().create_timer(0.5), "timeout")
	if bestMove:
		emit_signal("setPiece", bestMove)
	else:
		emit_signal("setPiece", Vector2(7, 7))

func checkMove(grid, position):
	var myScore = analyzeBoard(grid, position, color_)
	var bestEnemyScore = -2000

	for i in range(n):
		for j in range(n):
			if grid[i][j] == 0:
				grid[i][j] = -color_
				var enemyScore = analyzeBoard(grid, Vector2(i, j), -color_)
				grid[i][j] = 0
				if enemyScore > bestEnemyScore:
					bestEnemyScore = enemyScore
	return myScore - bestEnemyScore / 2

func getNeighbors(grid):
	var di = [0, 0, 1, -1, 1, -1, -1, 1]
	var dj = [1, -1, 0, 0, -1, 1, -1, 1]

	var neighbors = {}
	for i in range(n):
		for j in range(n):
			if grid[i][j] != 0:
				for k in range(di.size()):
					var vi = i + di[k]
					var vj = j + dj[k]

					if vi < 0 || vi >= n: continue
					if vj < 0 || vj >= n: continue

					if grid[vi][vj] == 0:
						neighbors[Vector2(vi, vj)] = true

	return neighbors.keys()

func analyzeBoard(grid, position, color):
	var openTwo = 0
	var openThree = 0
	var halfFour = 0
	var openFour = 0

	var directions = [Vector2(1, 0), Vector2(0, 1), Vector2(1, 1), Vector2(1, -1)]
	for direction in directions:
		var dp = 0
		for i in range(-4, 5):
			var v = position + i * direction
			var vi = v.x
			var vj = v.y

			if vi < 0 || vi >= n: continue
			if vj < 0 || vj >= n: continue

			if grid[vi][vj] == color:
				dp += 10
				if dp >= 50: return 1000
				elif dp == 45: halfFour += 1
			elif grid[vi][vj] == 0:
				if dp == 25: openTwo += 1
				elif dp == 35: openThree += 1
				elif dp == 40: halfFour += 1
				elif dp == 45:
					halfFour -= 1
					openFour += 1
				dp = 5

	if openFour > 0: return 220
	if halfFour > 1: return 220
	if halfFour > 0 && openThree > 0: return 200
	return openThree * 20 + halfFour * 10 + openTwo * 15
