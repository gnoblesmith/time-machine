extends Node2D
# todo - fix performance of this bad boy

var global

var input_points
var points

var width = 390 # todo - should get these from parent or something
var height = 190

var timeWindow = 30000
var minY
var maxY

var xScaler: float
var yScaler: float

func _ready():	
	global = get_node("/root/Global")
	self.get_node("PlotBackground/Line").width = 1
	
func update():
	if (global.focused_piece != null 
	&& global.focused_piece.store_history != null
	&& global.focused_piece.store_history.size() > 0):
		input_points = global.focused_piece.store_history
		
		findMinsAndMaxes()
		createScaledLine()
		self.get_node("PlotBackground/Line").points = PoolVector2Array(points)
	
func findMinsAndMaxes():
	minY = 999999999
	maxY = 0
	for point in input_points:
		if (point.y < minY): minY = point.y
		if (point.y > maxY): maxY = point.y
		
	xScaler = timeWindow
	yScaler = maxY - minY
	if (yScaler == 0): yScaler = 1

func createScaledLine():
	points = []
	
	var xFactor = width/xScaler
	var yFactor = height/yScaler
	
	var currentTimestamp = OS.get_ticks_msec()
	var oldestTimestamp = currentTimestamp - timeWindow
	
	for input_point in input_points:
		var newPoint = Vector2(
			(timeWindow - (currentTimestamp - input_point.x))*xFactor,
			height + (minY - input_point.y)*yFactor
		)
		points.append(newPoint)

func _on_Timer_timeout():
	update()
