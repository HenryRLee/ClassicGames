extends Node2D

var grid = []
onready var Tile = preload("res://Tile.tscn")
const size = 96
const n = 8
const m = 12
const images = 16
var imageShuffle = []
var active
var activeNode

func _ready():
	randomize()
	for i in range(images):
		for j in range(n * m / images):
			imageShuffle.append(i)
	imageShuffle.shuffle()
	for i in range(n):
		var row = []
		for j in range(m):
			var tile = Tile.instance()
			tile.translate(Vector2(j * size, i * size))
			tile.animation = str(imageShuffle[i * m + j])
			add_child(tile)
			row.append(tile)
		grid.append(row)

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			var j = int(event.position.x) / size
			var i = int(event.position.y) / size
			if !active:
				active = i * m + j
				activeNode = grid[i][j].duplicate()
				activeNode.scale = activeNode.scale * 1.1
				add_child(activeNode)
			else:
				if matching(i * m + j, active):
					erase(grid[i][j])
					erase(grid[active / m][active % m])
					print("matched")
				active = null
				remove_child(activeNode)
				activeNode.queue_free()

func matching(a, b):
	if a == b: return false
	if imageShuffle[a] != imageShuffle[b]: return false

	var image = imageShuffle[a]

	imageShuffle[a] = -1
	imageShuffle[b] = -1
	
	var ax = a % m
	var ay = a / m
	var bx = b % m
	var by = b / m

	if ax == bx:
		if connectedV(ax, ay, by): return true

	if ay == by:
		if connectedH(ay, ax, bx): return true

	for x in range(-1, m+1):
		if connectedH(ay, x, ax) && connectedH(by, x, bx) && connectedV(x, ay, by):
			return true

	for y in range(-1, n+1):
		if connectedV(ax, y, ay) && connectedV(bx, y, by) && connectedH(y, ax, bx):
			return true

	imageShuffle[a] = image
	imageShuffle[b] = image
	return false

func connectedV(x, y1, y2):
	if x < 0 || x >= m: return true
	if (y2 < y1):
		y1 ^= y2
		y2 ^= y1
		y1 ^= y2
	for y in range(max(y1, 0), min(y2+1, n)):
		if imageShuffle[y * m + x] != -1:
			return false
	return true

func connectedH(y, x1, x2):
	if y < 0 || y >= n: return true
	if (x2 < x1):
		x1 ^= x2
		x2 ^= x1
		x1 ^= x2
	for x in range(max(x1, 0), min(x2+1, m)):
		if imageShuffle[y * m + x] != -1:
			return false
	return true

func erase(node):
	remove_child(node)
	node.queue_free()
