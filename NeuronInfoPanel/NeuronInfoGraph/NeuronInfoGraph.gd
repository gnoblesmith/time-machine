extends Node2D
# todo - fix performance of this bad boy

var global

var input_points
var points

var width = 390 # todo - should get these from parent or something
var height = 190

var minX
var maxX
var minY
var maxY

var xScaler
var yScaler

func _ready():	
	global = get_node("/root/Global")
	self.get_node("PlotBackground/Line").width = 1
	
func update():
	if (global.focused_piece != null 
	&& global.focused_piece.history != null
	&& global.focused_piece.history.size() > 0):
		input_points = global.focused_piece.history
		
		findMinsAndMaxes()
		createScaledLine()
		self.get_node("PlotBackground/Line").points = PoolVector2Array(points)
	
func findMinsAndMaxes():
	minX = 999999999
	maxX = 0
	minY = 999999999
	maxY = 0
	for point in input_points:
		if (point.x < minX): minX = point.x
		if (point.x > maxX): maxX = point.x
		if (point.y < minY): minY = point.y
		if (point.y > maxY): maxY = point.y
		
	xScaler = maxX - minX
	yScaler = maxY - minY
	if (yScaler == 0): yScaler = 1

func createScaledLine():
	points = []
	
	for input_point in input_points:
		var newPoint = Vector2(
			(input_point.x - minX)*width/xScaler,
			height + (minY - input_point.y)*height/yScaler
		)
		points.append(newPoint)


func _on_Timer_timeout():
	update()
