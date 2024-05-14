# https://github.com/rbarongr/GodotFirstPersonController/blob/main/Player/player.gd

class_name Player extends CharacterBody3D

signal double_jump_ability_unlocked
signal air_dash_ability_unlocked

@export_category("Player")

@export_range(1, 35, 1) var speed: float = 10 # m/s
@export_range(10, 400, 1) var acceleration: float = 100 # m/s^2
@export_range(0.1, 3.0, 0.1) var jump_height: float = 1 # m
@export_range(0.1, 3.0, 0.1, "or_greater") var camera_sens: float = 1
# Define a sprint multiplier
@export var sprint_multiplier: float = 1.5

#AddsLaunchpadFunctionality
var external_force = Vector3.ZERO
var jump_force = 50.0
var is_double_jump_unlocked = false
var jump_count = 0
var jump_max = 2

var jumping: bool = false
var mouse_captured: bool = false

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var move_dir: Vector2 # Input direction for movement
var look_dir: Vector2 # Input direction for look/aim

var walk_vel: Vector3 # Walking velocity 
var grav_vel: Vector3 # Gravity velocity 
var jump_vel: Vector3 # Jumping velocity
var is_air_dash_unlocked: bool = false
var air_dash_used: bool = false
var air_dash_speed: float = 30.0  # Adjust this value based on desired dash intensity
var Ending_Dialogue = preload("res://Sounds/AscendEndingDialogue.mp3") # Ending Dialogue

@onready var camera: Camera3D = $Camera
# At the top of your script
@onready var dash_timer = $DashTimer
@onready var double_jump_unlock_sound = $DoubleJumpUnlockSound
@onready var air_dash_unlock_sound = $AirDashUnlockSound

func _ready() -> void:
	dash_timer.wait_time = 0.2  # Duration of the dash effect
	dash_timer.one_shot = true
	dash_timer.connect("timeout", Callable(self, "_on_DashTimer_timeout"))
	capture_mouse()
	check_unlocks()

func check_unlocks():
	if Global.apple_count >= 30:
		unlock_double_jump()
	if Global.apple_count >= 50:
		unlock_air_dash()



func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_dir = event.relative * 0.001
		if mouse_captured: _rotate_camera()
	if Input.is_action_just_pressed("jump"): jumping = true
	if Input.is_action_just_pressed("exit"): get_tree().quit()

func apply_push_force(push_force: Vector3):
	velocity += push_force  # Directly modify the built-in 'velocity'

func apply_external_force(force):
	external_force += force

func _physics_process(delta: float):
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var forward_dir = camera.global_transform.basis.z.normalized()
	var right_dir = camera.global_transform.basis.x.normalized()
	var direction = input_dir.x * right_dir + input_dir.y * forward_dir
	velocity += external_force
	external_force = Vector3.ZERO  # Reset after applying
	
	# Continue with normal movement and physics processing
	if is_on_floor():
		jump_count = 0
		air_dash_used = false
		dash_timer.stop()
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or (is_double_jump_unlocked and jump_count < jump_max):
			velocity.y = sqrt(3 * gravity * jump_height)
			jump_count += 1

	velocity.y -= gravity * delta

	if Input.is_action_pressed("sprint"):
		if not is_on_floor() and is_air_dash_unlocked and not air_dash_used:
			dash_timer.start()
			velocity += forward_dir * air_dash_speed
			air_dash_used = true
		elif is_on_floor():
			direction *= sprint_multiplier

	velocity.x = lerp(velocity.x, direction.x * speed, acceleration * delta)
	velocity.z = lerp(velocity.z, direction.z * speed, acceleration * delta)

	if mouse_captured:
		_handle_joypad_camera_rotation(delta)

	# Here we call move_and_slide without any arguments
	move_and_slide()

	if not dash_timer.is_stopped():
		velocity += forward_dir * (air_dash_speed * delta)
		# Your existing movement logic here
	
	# No need to pass 'velocity' or 'up_direction', just call 'move_and_slide()'
	move_and_slide()

	# You can reset the external force application after moving if desired
	# This ensures the push force only affects one frame unless continuously applied
	velocity.x = 0
	velocity.z = 0
	# Retain vertical velocity (gravity, jumps) unless you want to stop those too

func launch(launch_velocity: Vector3):
	print("Launching player with velocity:", launch_velocity)
	velocity += launch_velocity

func unlock_double_jump():
	is_double_jump_unlocked = true
	print("Unlocked Double Jump!")
	emit_signal("double_jump_ability_unlocked")
	double_jump_unlock_sound.play()

func unlock_air_dash():
	is_air_dash_unlocked = true
	print("Unlocked Air Dash!")
	emit_signal("air_dash_ability_unlocked")
	air_dash_unlock_sound.play()

func capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true

func release_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false

func _rotate_camera(sens_mod: float = 1.0) -> void:
	camera.rotation.y -= look_dir.x * camera_sens * sens_mod
	camera.rotation.x = clamp(camera.rotation.x - look_dir.y * camera_sens * sens_mod, -1.5, 1.5)

func _handle_joypad_camera_rotation(delta: float, sens_mod: float = 1.0) -> void:
	var joypad_dir: Vector2 = Input.get_vector("look_left","look_right","look_up","look_down")
	if joypad_dir.length() > 0:
		look_dir += joypad_dir * delta
		_rotate_camera(sens_mod)
		look_dir = Vector2.ZERO

func _walk(delta: float) -> Vector3:
	move_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var _forward: Vector3 = camera.global_transform.basis * Vector3(move_dir.x, 0, move_dir.y)
	var walk_dir: Vector3 = Vector3(_forward.x, 0, _forward.z).normalized()
	walk_vel = walk_vel.move_toward(walk_dir * speed * move_dir.length(), acceleration * delta)
	return walk_vel

func _gravity(delta: float) -> Vector3:
	grav_vel = Vector3.ZERO if is_on_floor() else grav_vel.move_toward(Vector3(0, velocity.y - gravity, 0), gravity * delta)
	return grav_vel

func _jump(delta: float) -> Vector3:
	$jump.play()
	# Jump logic consolidated here
	if jumping:
		if jump_count < jump_max:
			jump_vel = Vector3(0, sqrt(3 * jump_height * -gravity), 0)
			jump_count += 1
			jumping = false
		else:
			jumping = false
	return jump_vel

func play_pickup_sound():
	$pickup.play()

func play_Ending_Dialogue():
	# Play the sound
	$Ending_Dialogue.play()
	
