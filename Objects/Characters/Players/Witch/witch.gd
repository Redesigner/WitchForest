extends CharacterBody3D

@onready var camera:Camera3D = %Camera

@export_group("Movement")
@export var max_speed:float = 2.0
@export var acceleration:float = 10.0

var camera_sin:float = 0.0
var camera_cos:float = 0.0

func _ready():
	camera_sin = sin(-camera.global_rotation.y)
	camera_cos = cos(-camera.global_rotation.y)
	print(camera_sin)

func _physics_process(delta):
	var input_vector:Vector2 = Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")
	
	var desired_velocity:Vector3 = \
		Vector3(camera_cos * input_vector.x - camera_sin * input_vector.y , 0.0, \
		camera_sin * input_vector.x + camera_cos * input_vector.y) * max_speed \
		if input_vector \
		else Vector3(0.0, 0.0, 0.0)
	velocity = velocity.move_toward(desired_velocity, delta * acceleration)
	move_and_slide()
