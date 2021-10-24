extends CanvasLayer
var global

func _ready():
	global = get_node("/root/Global")

func _input(event):
	if event is InputEventMouseMotion:
		global.ghostPieceOnMouseMove(event.position)
		
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and not event.pressed:
		global.setMouseState(global.MouseState.NOTHING)
		global.destroyGhostPiece()
		global.clearFocus()
