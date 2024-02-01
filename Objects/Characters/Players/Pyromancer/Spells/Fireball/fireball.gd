extends Area3D

var destination:Vector3 = Vector3(0.0, 0.0, 0.0)
var speed:float = 10.0

func _physics_process(delta):
	global_position = move_toward_constant(global_position, destination, speed, delta)
	if (has_overlapping_bodies()):
		var result:Array[Node3D] = get_overlapping_bodies()
		for overlapped_body:Node3D in result:
			if (overlapped_body is Enemy):
				overlapped_body.take_damage(2.0)
	
func move_toward_constant(current_position:Vector3, desired_position:Vector3, speed:float, delta:float):
	var delta_position:Vector3 = desired_position - current_position
	var distance:float = delta_position.length()
	var direction:Vector3 = delta_position.normalized()
	var distance_moved_this_tick:float = speed * delta
	
	if (distance_moved_this_tick > distance):
		queue_free()
		return desired_position
	
	return current_position + direction * distance_moved_this_tick
