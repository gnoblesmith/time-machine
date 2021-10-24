extends Control

var global
const ConnectorResource = preload("res://Connector/Connector.tscn")


var sponged = 0

func _ready():
	global = get_node("/root/Global")

func _process(delta):
	if (sponged > 0):
		sponged -= delta
	
	if (sponged <= 0):
		sponged = 0
		self.get_node("Label").text = "Empty"
	else:
		self.get_node("Label").text = str(sponged)
	

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.pressed:
		if global.mouse_state == global.MouseState.MAKE_CONNECTOR_A:
			var newConnector = ConnectorResource.instance()
			
			newConnector.points = [
				Vector2(get_viewport().get_mouse_position().x, get_viewport().get_mouse_position().y),
				Vector2(get_viewport().get_mouse_position().x, get_viewport().get_mouse_position().y)
			]
			newConnector.setConnectionA(self)
			newConnector.connect("pulse_a", self, "onPulseReceived")
			global.setupGhostPiece(newConnector)
			global.setMouseState(global.MouseState.MAKE_CONNECTOR_B)
			
		elif global.mouse_state == global.MouseState.MAKE_CONNECTOR_B:
			global.ghost_piece.setConnectionB(self)
			global.ghost_piece.connect("pulse_b", self, "onPulseReceived")
			global.promoteGhostPiece()
			global.setMouseState(global.MouseState.NOTHING)
			
func onPulseReceived(strength):
	print("pulse received")
	sponged += strength
	pass;
