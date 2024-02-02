class_name Math

static func angle_between(angle1:float, angle2:float):
	if (angle1 > 360.0 || angle1 < 0.0):
		angle1 = wrapf(angle1, 0.0, 360.0)
		
	if (angle2 > 360.0 || angle2 < 0.0):
		angle2 = wrapf(angle2, 0.0, 360.0)

	var delta_angle:float = angle2 - angle1
	if (delta_angle > 180.0):
		delta_angle -= 360.0
	elif (delta_angle < -180.0):
		delta_angle += 360.0

	return delta_angle


static func angle_interp_to_constant(angle:float, destination_angle:float, rate:float):
	var delta_angle:float = angle_between(angle, destination_angle)
	delta_angle = clamp(delta_angle, -rate, rate)
	return angle + delta_angle


static func point_in_circle(radius:float):
	var point_radius:float = radius * sqrt(randf())
	var theta:float = randf() * 2.0 * PI
	return Vector2(point_radius * cos(theta), point_radius * sin(theta))


static func random_launch_angle():
	var launch_pitch:float = randf_range(PI / 4.0, PI / 2.0)
	var launch_yaw:float = randf_range(-PI, PI)
	var launch_speed:float = randf_range(2.5, 10.0)
	var circle_radius:float = cos(launch_pitch)
	return Vector3(cos(launch_yaw) * circle_radius, sin(launch_pitch), sin(launch_yaw) * circle_radius) * launch_speed
