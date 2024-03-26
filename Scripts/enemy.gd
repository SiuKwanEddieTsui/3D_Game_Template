extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
@export var speed = 3
var is_nav_loaded : bool = false

func _physics_process(delta):
	if not is_nav_loaded:
		is_nav_loaded = true
		return
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * speed
	velocity = new_velocity
	move_and_slide()
	
func update_target_location(target_location):
	print('target_location', target_location)
	nav_agent.set_target_position(target_location)
