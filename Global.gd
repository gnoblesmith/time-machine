extends Node

enum MouseState {
	NOTHING,
	MAKE_TIMER,
	MAKE_RECEIVER,
	MAKE_CONNECTOR_A,
	MAKE_CONNECTOR_B
}

var mouse_state = MouseState.NOTHING

func setMouseState(state):
	print("set mouse state to " + str(state))
	mouse_state = state

var highlighted_piece: Object

var ghost_piece: Object
var ghost_piece_container

func setupGhostPieceContainer(place):
	ghost_piece_container = place
	
func setupGhostPiece(instance):
	var modulate = instance.get_modulate()
	modulate.a = 0.5
	instance.set_modulate(modulate)
	if (instance.get_class() == "Control"):
		instance.set_mouse_filter(2) # mouse filter ignore
	ghost_piece = instance
	ghost_piece_container.add_child(ghost_piece)
	
func promoteGhostPiece():
	if is_instance_valid(ghost_piece) && ghost_piece != null:
		var modulate = ghost_piece.get_modulate()
		modulate.a = 1
		ghost_piece.set_modulate(modulate)
		if (ghost_piece.get_class() == "Control"):
			ghost_piece.set_mouse_filter(0) # mouse filter stop
		ghost_piece = null
	
func destroyGhostPiece():
	if is_instance_valid(ghost_piece) && ghost_piece != null:
		ghost_piece.queue_free()
	
func ghostPieceOnMouseMove(position):
	if is_instance_valid(ghost_piece) && ghost_piece != null:
		if (ghost_piece.get_class() == "Control"):
			ghost_piece.set_position(position)
		if (ghost_piece.get_class() == "Line2D"):
			ghost_piece.set_point_position(1, Vector2(get_viewport().get_mouse_position()))

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
