extends Node3D

@export var cursor_raycast_length:float = 50.0
@export_flags_3d_physics var raycast_mask:int = 2

func _process(_delta):
	update_cursor_world_position()

func update_cursor_world_position():
	var space_state:PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var cursor_position_screen:Vector2 = get_viewport().get_mouse_position()
	var query_start:Vector3 = get_camera().project_ray_origin(cursor_position_screen)
	var query_end:Vector3 = query_start + get_camera().project_ray_normal(cursor_position_screen) * cursor_raycast_length
	var query_parameters:PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(query_start, query_end, raycast_mask)
	
	var result:Dictionary = space_state.intersect_ray(query_parameters)
	
	if (!result):
		visible = false
		return
	else:
		visible = true
	
	global_position = result["position"]
	
func get_camera():
	return get_viewport().get_camera_3d()
