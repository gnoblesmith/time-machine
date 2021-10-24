extends Control

var global

const TransmitterResource = preload("res://Transmitter/TimerTransmitter.tscn")
const ReceiverResource = preload("res://Receiver/TimerReceiver.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	global = get_node("/root/Global")

func _gui_input(event):
	if event is InputEventMouseButton:
		print("mouse event toolbar")
	

func _on_MakeConnector_pressed():
	global.destroyGhostPiece()
	setMouseState(global.MouseState.MAKE_CONNECTOR_A)


func _on_MakeTimer_pressed():
	global.destroyGhostPiece()
	global.setupGhostPiece(TransmitterResource.instance())
	setMouseState(global.MouseState.MAKE_TIMER)


func _on_MakeReceiver_pressed():
	global.destroyGhostPiece()
	global.setupGhostPiece(ReceiverResource.instance())
	setMouseState(global.MouseState.MAKE_RECEIVER)
	
func setMouseState(new_state):
	global.setMouseState(new_state)
	
