extends Control

var global

const NeuronResource = preload("res://Neuron/Neuron.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	global = get_node("/root/Global")

func _gui_input(event):
	if event is InputEventMouseButton:
		print("mouse event toolbar")	

func _on_MakeConnector_pressed():
	global.destroyGhostPiece()
	setMouseState(global.MouseState.MAKE_CONNECTOR_A)


func _on_MakeSource_pressed():
	global.destroyGhostPiece()
	var source = NeuronResource.instance()
	source.setAsSource(1)
	global.setupGhostPiece(source)
	setMouseState(global.MouseState.MAKE_SOURCE)

func _on_MakeSink_pressed():
	global.destroyGhostPiece()
	var sink = NeuronResource.instance()
	sink.setAsSink()
	global.setupGhostPiece(sink)
	setMouseState(global.MouseState.MAKE_SINK)

func _on_MakeNeuron_pressed():
	global.destroyGhostPiece()
	var neuron = NeuronResource.instance()
	neuron.setAsNeuron()
	global.setupGhostPiece(neuron)
	setMouseState(global.MouseState.MAKE_NEURON)
	
func setMouseState(new_state):
	global.setMouseState(new_state)

