extends Polygon2D

signal pulse_arrived(strength)

var _start
var _end

var timeTraveled = 0
var totalTravelTime

var travelSpeed = 50 # ??? units?

var initialStrength
var strength
var weakeningFactor 
var defaultWidth

func _ready():
	timeTraveled = 0
	initialStrength = 1
	strength = initialStrength
	weakeningFactor = 10
	defaultWidth = 20
	pass 

func setEndpoints(start, end):
	_start = start
	_end = end
	
	var length = Vector2(_end.x - _start.x, _end.y - _start.y).length()
	totalTravelTime = length / travelSpeed
	 
	# todo - figure out rotation
	
	self.set_offset(_start)
	
	
func _process(delta):
	timeTraveled += delta
	
	var newX = (_end.x - _start.x)*(timeTraveled / totalTravelTime) + _start.x
	var newY = (_end.y - _start.y)*(timeTraveled / totalTravelTime) + _start.y
	
	var position = Vector2(newX, newY)
	self.set_offset(position)
	
	strength = initialStrength / (timeTraveled*timeTraveled) * weakeningFactor
	if (strength > initialStrength): strength = initialStrength
	setPointsFromStrength(strength)
	
	if (timeTraveled >= totalTravelTime):
		get_parent().remove_child(self)
		emit_signal("pulse_arrived", strength)
		
func setPointsFromStrength(s):
	var mag = (defaultWidth / 2) * (s / initialStrength)
	
	var a = Vector2(-mag, -mag)
	var b = Vector2(-mag, mag)
	var c = Vector2(mag, mag)
	var d = Vector2(mag, -mag)
	
	var pts = PoolVector2Array([a, b, c, d])
	self.set_polygon(pts)
	
	
