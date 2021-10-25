extends ColorRect

var global

const PulseResource = preload("res://Connector2/Pulse/Pulse.tscn")

var connectionA
var connectionB

signal pulse_a(strength)
signal pulse_b(strength)

# Called when the node enters the scene tree for the first time.
func _ready():
	global = get_node("/root/Global")
	
func onMouseEntered():
	if (global.mouse_state == global.MouseState.DELETE):
		self.color = Color.red
	
func onMouseExited():
	self.color = Color.white

func setConnectionA(instance):
	connectionA = instance
	connectionA.connect("pulse", self, "onPulseA")
	
func setConnectionB(instance):
	connectionB = instance
	connectionB.connect("pulse", self, "onPulseB")
	
	self.connect("mouse_entered", self, "onMouseEntered")
	self.connect("mouse_exited", self, "onMouseExited")
	
func beginSetupConnector(startPos):
	self.rect_position = Vector2(startPos)

func onPulseA(strength):
	if !connectionA || !connectionB:
		return

	var newPulse = PulseResource.instance()
	newPulse.setEndpoints(Vector2(0,0), Vector2(self.rect_size.x, 0))
	newPulse.setInitialStrength(strength)
	newPulse.connect("pulse_arrived", self, "onPulseArrivedAtB")
	self.add_child(newPulse)
	
func onPulseB(strength):
	if !connectionA || !connectionB:
		return

	var newPulse = PulseResource.instance()
	newPulse.setEndpoints(Vector2(self.rect_size.x, 0), Vector2(0,0))
	newPulse.setInitialStrength(strength)
	newPulse.connect("pulse_arrived", self, "onPulseArrivedAtA")
	self.add_child(newPulse)
	
func onPulseArrivedAtB(strength):
	emit_signal("pulse_b", strength)
	
func onPulseArrivedAtA(strength):
	emit_signal("pulse_a", strength)

func onMoveDuringGhostState(position):
	var current_mouse_position = get_viewport().get_mouse_position()
	
	var delta = Vector2(position.x-self.rect_position.x, position.y-self.rect_position.y)
	var angle = delta.angle_to(Vector2(1, 0))
	
	self.rect_size = Vector2(delta.length(), 5)
	self.rect_rotation = -rad2deg(angle)

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.pressed:
		if global.mouse_state == global.MouseState.DELETE:
			get_parent().remove_child(self)
			global.setMouseState(global.MouseState.NOTHING)
			pass
