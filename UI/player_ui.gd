extends Control

@onready var controller_hints:Label = %ControllerHints

func set_control_tips(action_hint:String):
	controller_hints.text = action_hint
	controller_hints.visible = true

func hide_control_tips():
	controller_hints.visible = false
