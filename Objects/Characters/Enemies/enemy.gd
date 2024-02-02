class_name Enemy
extends CharacterBody3D

@onready var navigation_region_3d:NavigationRegion3D = get_node("../NavigationRegion3D")
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export_category("Health")
@export var current_health:float = 10.0
@export var max_health:float = 10.0

@export_category("Movement")
@export var rotation_speed:float = 180.0
@export var max_speed:float = 2.0
@export var acceleration:float = 2.0
var desired_position:Vector3

# Wander timers
var current_wander_time:float = 0.0
var next_wander_time:float = 0.1
var max_wander_time:float = 5.0
var min_wander_time:float = 4.0

enum State { idle, aggressive}
@export_category("Targeting")
var current_state:State = State.idle
var target:Witch = null
@export var minimum_distance:float = 2.0

@export_category("Stun")
@export var stun_time:float = 0.25
var current_stun_time:float = 0.0
var stunned:bool = false

@export_category("Drops")
@export var drop_table_items:Array[PackedScene]
@export var drop_table_rate:Array[float]

func _ready():
	if (drop_table_items.size() != drop_table_rate.size()):
		print("Mismatch between drop table counts")

func take_damage(source:Witch, damage:float, direction:Vector3):
	current_health -= damage
	var direction_normalized:Vector3 = Vector3(direction.x, 0.0, direction.z).normalized()
	velocity = direction_normalized * 3.0 + Vector3(0.0, 5.0, 0.0)
	stunned = true
	if (current_health <= 0.0):
		current_health = 0.0
		on_death()
		return
	
	if (current_health >= max_health):
		current_health = max_health
		
	if (source != null):
		target = source
		current_state = State.aggressive


func on_death():
	for i:int in range(0, drop_table_items.size()):
		var drop_item:PackedScene = drop_table_items[i]
		var drop_rate:float = drop_table_rate[i]
		if (randf() <= drop_rate):
			spawn_item(drop_item)
	queue_free()

func spawn_item(item_scene:PackedScene):
	var item:RigidBody3D = item_scene.instantiate()
	get_tree().root.add_child(item)
	item.global_position = global_position
	item.apply_impulse(Math.random_launch_angle())

func _process(delta):
	if (stunned):
		current_stun_time += delta
		if (current_stun_time >= stun_time):
			current_stun_time = 0.0
			stunned = false
	
	match current_state:
		State.idle:
			current_wander_time += delta
			if (current_wander_time >= next_wander_time):
				wander()
		State.aggressive:
			if (target == null):
				return
			var delta_position:Vector3 = (target.global_position - global_position)
			if (delta_position.length_squared() <= minimum_distance * minimum_distance):
				return
			var target_direction:Vector3 = delta_position.normalized()
			var closest_position:Vector3 = target.global_position - target_direction * minimum_distance
			desired_position = get_position_in_map(closest_position)


func _physics_process(delta):	
	if (!is_on_floor()):
		velocity.y -= gravity * delta
	else:
		if (!stunned):
			var delta_position:Vector3 = desired_position - global_position
			velocity = velocity.move_toward(delta_position.normalized() * max_speed, acceleration)
			look_at_position(target.global_position if (target != null) else desired_position, delta, rotation_speed)
		else:
			velocity = velocity.move_toward(Vector3(), acceleration)
	move_and_slide()	

func wander():
	current_wander_time -= next_wander_time
	next_wander_time = randf_range(min_wander_time, max_wander_time)
	var point_in_circle:Vector2 = Math.point_in_circle(5.0)
	var random_location:Vector3 = Vector3(point_in_circle.x + global_position.x, global_position.y, point_in_circle.y + global_position.z) 
	desired_position = get_position_in_map(random_location)


func look_at_position(target_position:Vector3, delta:float, speed:float):
	var delta_position:Vector3 = target_position - global_position
	var direction:Vector2 = Vector2(delta_position.x, delta_position.z).normalized()
	var current_yaw:float = global_rotation_degrees.y
	var desired_yaw:float = rad_to_deg(atan2(direction.x, direction.y))
	rotation_degrees.y = Math.angle_interp_to_constant(current_yaw, desired_yaw, speed * delta)


func get_position_in_map(new_position:Vector3):
	return NavigationServer3D.map_get_closest_point(navigation_region_3d.get_navigation_map(), new_position)
