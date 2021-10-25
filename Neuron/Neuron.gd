extends Control

var global
const ConnectorResource = preload("res://Connector2/Connector.tscn")
signal pulse(strength)

enum NeuronType {
	NEURON,
	SINK,
	SOURCE,
	THRESHOLD
}
var type

var strength: float = 1
var store: float = 0.0
var store_history
var store_drainage_factor: float = 0.0 # per second

var connected_connectors

var relay_threshold: float = 6.0

var pulse_history

func _ready():
	store_history = []
	pulse_history = []
	connected_connectors = []
	global = get_node("/root/Global")
	self.connect("mouse_entered", self, "onMouseEntered")
	self.connect("mouse_exited", self, "onMouseExited")

func _process(delta):
	if (store > 0):
		store -= delta*store_drainage_factor
		if (store < 0): store = 0
		
		if (type == NeuronType.THRESHOLD && store > relay_threshold):
			emit_signal("pulse", strength)
			store -= relay_threshold
		
	store_history.append(Vector2(OS.get_ticks_msec(), store))

func setAsNeuron():
	type = NeuronType.NEURON
	self.get_node("Main").color = Color.purple
	
func setAsThreshold():
	type = NeuronType.THRESHOLD
	self.get_node("Main").color = Color.green

func setAsSink():
	type = NeuronType.SINK
	self.get_node("Main").color = Color.blue

func setAsSource(time):
	type = NeuronType.SOURCE
	self.get_node("Main").color = Color.red
	
	var timer = Timer.new()
	timer.autostart = true
	timer.one_shot = false
	timer.wait_time = time
	timer.connect("timeout", self, "_on_Timer_timeout")
	self.add_child(timer)

func _on_Timer_timeout():
	emit_signal("pulse", strength)

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.pressed:
		if global.mouse_state == global.MouseState.MAKE_CONNECTOR_A:
			var newConnector = ConnectorResource.instance()
			
			newConnector.beginSetupConnector(get_viewport().get_mouse_position())
			newConnector.setConnectionA(self)
			newConnector.connect("pulse_a", self, "onPulseReceived")
			connected_connectors.append(newConnector)
			
			global.setupGhostPiece(newConnector)
			global.setMouseState(global.MouseState.MAKE_CONNECTOR_B)
			
		elif global.mouse_state == global.MouseState.MAKE_CONNECTOR_B:
			connected_connectors.append(global.ghost_piece)
			global.ghost_piece.setConnectionB(self)
			global.ghost_piece.connect("pulse_b", self, "onPulseReceived")
			global.promoteGhostPiece()
			global.setMouseState(global.MouseState.NOTHING)
			
		elif global.mouse_state == global.MouseState.DELETE:
			for connector in connected_connectors:
				connector.get_parent().remove_child(connector)
			
			get_parent().remove_child(self)
			global.setMouseState(global.MouseState.NOTHING)
			pass
			
		elif global.mouse_state == global.MouseState.NOTHING:
			global.setFocus(self)
			pass
			
func onPulseReceived(_strength):
	store += _strength
	pass;
	
func setFocus():
	self.get_node("FocusHighlight").visible = true
	
func loseFocus():
	self.get_node("FocusHighlight").visible = false

func onMouseEntered():
	if (global.mouse_state == global.MouseState.DELETE):
		self.get_node("DeleteHighlight").visible = true
	else:
		self.get_node("GentleHighlight").visible = true

func onMouseExited():
	self.get_node("DeleteHighlight").visible = false
	self.get_node("GentleHighlight").visible = false
	
func onMoveDuringGhostState(position):
	self.set_position(position)
	
