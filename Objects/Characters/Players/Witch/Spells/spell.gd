class_name Spell
extends Node

@export var cooldown_length:float = 1.0
var current_time:float = 0.0
var on_cooldown:bool = false

func _process(delta):
	if (on_cooldown):
		current_time += delta
		
		if (current_time >= cooldown_length):
			current_time = cooldown_length
			on_cooldown = false

func try_cast(source:Witch, location:Vector3):
	if (on_cooldown):
		return
	current_time = 0.0
	on_cooldown = true
	cast(source, location)
	
func cast(_source:Witch, _location:Vector3):
	pass
