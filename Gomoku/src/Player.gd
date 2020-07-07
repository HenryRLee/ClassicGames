extends Node2D

signal setPiece(position)

const size = 32
const n =  15

func _ready():
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			var x = int(round(to_local(event.position).x / size))
			var y = int(round(to_local(event.position).y / size))
			if x >= 0 && x < 15 && y >= 0 && y < 15:
				emit_signal("setPiece", Vector2(x, y))

func setColor(color):
	pass
