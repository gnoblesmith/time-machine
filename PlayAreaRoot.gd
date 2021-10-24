extends Control

const TransmitterResource = preload("res://Transmitter/TimerTransmitter.tscn")
const ReceiverResource = preload("res://Receiver/TimerReceiver.tscn")

var global

func _ready():
	global = get_node("/root/Global")
	global.setupGhostPieceContainer(self)

func _gui_input(event):
	if event is InputEventMouseButton:
		print("mouse event play area")
	
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.pressed:
		if (global.mouse_state == global.MouseState.MAKE_TIMER):
			var newTransmitter = TransmitterResource.instance()
			newTransmitter.set_position(event.position)
			global.setMouseState(global.MouseState.NOTHING)
			global.promoteGhostPiece()
			
		if (global.mouse_state == global.MouseState.MAKE_RECEIVER):
			var newReceiver = ReceiverResource.instance()
			newReceiver.set_position(event.position)
			global.setMouseState(global.MouseState.NOTHING)
			global.promoteGhostPiece()
			
		if (global.mouse_state == global.MouseState.MAKE_CONNECTOR_A):
			pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
