extends Spell

@export var fireball_scene:PackedScene
@export var fireball_speed:float = 10.0

func cast(source:Witch, location:Vector3):
	var witch_position:Vector3 = source.global_position
	var fireball_direction:Vector3 = (location - witch_position).normalized()
	var fireball_direction_2D:Vector3 = Vector3(fireball_direction.x, 0.0, fireball_direction.z).normalized()
	var fireball:Node3D = fireball_scene.instantiate()
	get_tree().root.add_child(fireball)
	fireball.global_position = witch_position + fireball_direction_2D
	fireball.destination = location + Vector3(0.0, 1.0, 0.0)
	fireball.speed = fireball_speed
	fireball.source = source
