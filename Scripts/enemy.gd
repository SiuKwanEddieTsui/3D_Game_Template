extends CharacterBody3D

signal update_console(message)

@onready var nav_agent = $NavigationAgent3D

@export var speed = 3

var is_nav_loaded : bool = false

# Export variable to adjust the push frequency easily from the editor
@export var push_cooldown: float = 1.5

# Reference to the cooldown timer
@onready var push_timer = $PushTimer

func _ready():
	push_timer.wait_time = push_cooldown
	push_timer.start()

func _physics_process(delta):
	if not is_nav_loaded:
		is_nav_loaded = true
		return
	
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * speed
	velocity = new_velocity
	move_and_slide()

func push_player(player):
	var push_direction = player.global_transform.origin - global_transform.origin
	push_direction.y = 0 # Prevent pushing the player upwards
	push_direction = push_direction.normalized()
	var push_strength = 10 # Adjust push strength as needed
	player.velocity += push_direction * push_strength
	emit_signal("update_console", "Enemy pushed you!")

func update_target_location(target_location):
	nav_agent.set_target_position(target_location)

func _on_area_3d_body_entered(body):
	if body is RigidBody3D:
		queue_free()
	if body.is_in_group("Player") and not push_timer.is_stopped():
		push_player(body)
		push_timer.start() # Reset the timer after pushing



