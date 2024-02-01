class_name Enemy
extends CharacterBody3D

@export var current_health:float = 10.0
@export var max_health:float = 10.0

func take_damage(damage:float):
	current_health -= damage
	if (current_health <= 0.0):
		current_health = 0.0
		on_death()
		return
	if (current_health >= max_health):
		current_health = max_health
	
func on_death():
	queue_free()
