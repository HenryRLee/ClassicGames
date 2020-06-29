extends Node2D

var v

func draw(_v):
	v = _v
	update()

func _draw():
	if v:
		draw_polyline(PoolVector2Array(v), Color.royalblue, 5)
