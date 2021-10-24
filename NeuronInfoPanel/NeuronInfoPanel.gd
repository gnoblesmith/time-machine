extends Control

var global

func _ready():
	self.visible = false
	global = get_node("/root/Global")
	global.setInfoPanel(self)
