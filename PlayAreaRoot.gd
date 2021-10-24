extends Control

const NeuronResource = preload("res://Neuron/Neuron.tscn")

var global

func _ready():
	global = get_node("/root/Global")
	global.setupGhostPieceContainer(self)

func _gui_input(event):
	if event is InputEventMouseButton:
		print("mouse event play area")
	
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.pressed:
		if (global.mouse_state == global.MouseState.MAKE_SOURCE):
			global.setMouseState(global.MouseState.NOTHING)
			global.promoteGhostPiece()
			
		if (global.mouse_state == global.MouseState.MAKE_SINK):
			global.setMouseState(global.MouseState.NOTHING)
			global.promoteGhostPiece()
			
		if (global.mouse_state == global.MouseState.MAKE_NEURON):
			global.setMouseState(global.MouseState.NOTHING)
			global.promoteGhostPiece()
			
		if (global.mouse_state == global.MouseState.MAKE_THRESHOLD):
			global.setMouseState(global.MouseState.NOTHING)
			global.promoteGhostPiece()
			
		if (global.mouse_state == global.MouseState.MAKE_CONNECTOR_A):
			pass
