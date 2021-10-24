extends Control

var points

func _ready():
	points = []
	points.append(Vector2(0,0))
	points.append(Vector2(25,25))
	points.append(Vector2(50,50))
	points.append(Vector2(75,75))
	
	self.get_node("PlotBackground/Line").width = 1
	
	update()
	
func update():
	self.get_node("PlotBackground/Line").points = PoolVector2Array(points)

