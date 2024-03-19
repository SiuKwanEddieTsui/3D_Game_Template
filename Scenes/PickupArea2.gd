extends Area3D

@onready var hand = $"../hand"  # Make sure this matches your scene structure
@onready var camera = $".."  # Make sure this matches your scene structure

var picked_object : RigidBody3D = null
var is_picked = false

const PULL_SPEED = 4.0
const THROW_FORCE = 10.0
const UPWARD_THROW_ADDITION = Vector3(0, 1, 0)  # Adds a natural upward trajectory

func _physics_process(_delta: float) -> void:
	if picked_object and is_picked:
		var object_position = picked_object.global_transform.origin
		var hand_position = hand.global_transform.origin
		picked_object.linear_velocity = (hand_position - object_position) * PULL_SPEED

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("picked") and picked_object:
		is_picked = not is_picked
		if not is_picked and picked_object:
			$"../../pickup".play()
			picked_object.linear_velocity = Vector3.ZERO
			picked_object.angular_velocity = Vector3.ZERO
			picked_object = null

	if event.is_action_pressed("throw") and is_picked and picked_object:
		var dir = -camera.global_transform.basis.z.normalized() + UPWARD_THROW_ADDITION
		picked_object.apply_central_impulse(dir * THROW_FORCE)
		picked_object = null
		is_picked = false

func _on_body_entered(body: Node) -> void:
	if not is_picked and body is RigidBody3D:
		picked_object = body
