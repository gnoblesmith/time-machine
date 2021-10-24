extends Line2D

const PulseResource = preload("res://Connector/Pulse/Pulse.tscn")

var connectionA
var connectionB

signal pulse_a(strength)
signal pulse_b(strength)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setConnectionA(instance):
	connectionA = instance
	connectionA.connect("pulse", self, "onPulseA")
	
func setConnectionB(instance):
	connectionB = instance
	connectionB.connect("pulse", self, "onPulseB")

func onPulseA(strength):
	if !connectionA || !connectionB:
		return

	var newPulse = PulseResource.instance()
	newPulse.setEndpoints(self.points[0], self.points[1])
	newPulse.setInitialStrength(strength)
	newPulse.connect("pulse_arrived", self, "onPulseArrivedAtB")
	self.add_child(newPulse)
	
func onPulseB(strength):
	if !connectionA || !connectionB:
		return

	var newPulse = PulseResource.instance()
	newPulse.setEndpoints(self.points[1], self.points[0])
	newPulse.setInitialStrength(strength)
	newPulse.connect("pulse_arrived", self, "onPulseArrivedAtA")
	self.add_child(newPulse)
	
func onPulseArrivedAtB(strength):
	emit_signal("pulse_b", strength)
	
func onPulseArrivedAtA(strength):
	emit_signal("pulse_a", strength)
	

