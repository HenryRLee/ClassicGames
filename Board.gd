extends Node2D

signal win

var grid
onready var Tile = preload("res://Tile.tscn")
onready var Drawer = preload("res://Drawer.tscn")
const size = 96
const n = 8
const m = 12
const images = 16
var imageShuffle
var active
var activeTile
var remaining = n * m

func _ready():
	active = -1
	remaining = n * m
	imageShuffle = []
	grid = []
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
			var j = int(to_local(event.position).x) / size
			var i = int(to_local(event.position).y) / size

			if j < 0 || j >= m: return
			if i < 0 || i >= n: return

			if imageShuffle[i * m + j] == -1:
				if active != -1:
					erase(activeTile)
					active = -1
				return

			if active == -1:
				active = i * m + j
				activeTile = Tile.instance()
				activeTile.scale = activeTile.scale * 1.1
				activeTile.translate(Vector2(j * size, i * size))
				activeTile.animation = str(imageShuffle[active])
				add_child(activeTile)
			else:
				if matching(i * m + j, active):
					erase(grid[i][j])
					erase(grid[active / m][active % m])
					remaining -= 2
					if remaining == 0: emit_signal("win")
				erase(activeTile)
				active = -1

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
		if connectedV(ax, ay, by):
			draw([Vector2(ax, ay), Vector2(bx, by)])
			return true

	if ay == by:
		if connectedH(ay, ax, bx):
			draw([Vector2(ax, ay), Vector2(bx, by)])
			return true

	for x in range(-1, m+1):
		if connectedH(ay, x, ax) && connectedH(by, x, bx) && connectedV(x, ay, by):
			draw([Vector2(ax, ay), Vector2(x, ay),\
				  Vector2(x, ay), Vector2(x, by),\
				  Vector2(x, by), Vector2(bx, by)])
			return true

	for y in range(-1, n+1):
		if connectedV(ax, y, ay) && connectedV(bx, y, by) && connectedH(y, ax, bx):
			draw([Vector2(ax, ay), Vector2(ax, y),\
				  Vector2(ax, y), Vector2(bx, y),\
				  Vector2(bx, y), Vector2(bx, by)])
			return true

	imageShuffle[a] = image
	imageShuffle[b] = image
	return false

func draw(v):
	var drawer = Drawer.instance()
	for i in range(v.size()):
		v[i] = to_global(v[i] * size - Vector2(size/8, size/8))
	print(v)
	drawer.draw(v)
	add_child(drawer)

	yield(get_tree().create_timer(0.2), "timeout")
	remove_child(drawer)
	drawer.queue_free()

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

func _on_HUD_restart():
	_ready()
