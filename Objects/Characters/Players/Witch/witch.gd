class_name Witch
extends CharacterBody3D

@onready var camera:Camera3D = %Camera

@export_group("Movement")
@export var max_speed:float = 4.0
@export var acceleration:float = 20.0

@export_group("Spells")
@export var primary_spell_path:NodePath
@onready var primary_spell = get_node(primary_spell_path)

@onready var mesh:Node3D = get_node("witch")

var camera_sin:float = 0.0
var camera_cos:float = 0.0

func _ready():
	camera_sin = sin(-camera.global_rotation.y)
	camera_cos = cos(-camera.global_rotation.y)

func _physics_process(delta):
	var input_vector:Vector2 = Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")
	var input_vector_rotated:Vector2 = Vector2(camera_cos * input_vector.x - camera_sin * input_vector.y, camera_sin * input_vector.x + camera_cos * input_vector.y)
	var desired_velocity:Vector3 = \
		Vector3(input_vector_rotated.x , 0.0, input_vector_rotated.y) * max_speed \
		if input_vector \
		else Vector3(0.0, 0.0, 0.0)
	velocity = velocity.move_toward(desired_velocity, delta * acceleration)
	if (input_vector):
		var desired_yaw:float = atan2(input_vector_rotated.x, input_vector_rotated.y)
		mesh.global_rotation_degrees.y = Math.angle_interp_to_constant(mesh.global_rotation_degrees.y, rad_to_deg(desired_yaw), delta * 1800.0)
	move_and_slide()

func _input(event):
	if (event.is_action_pressed("primary_action")):
		primary_spell.try_cast(self, %Cursor.global_position)
