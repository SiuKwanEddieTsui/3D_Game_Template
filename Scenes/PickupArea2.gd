extends Area3D

@onready var hand = $"../hand"
@onready var camera = $".."

var pull_speed = 2
var throw_speed = 8

var pickup_object = null
var is_picked = false

func _physics_process(_delta):
	# Check that we have an item picked up
	if pickup_object and is_picked:
		# Get the distance between object and hand
		var obj_pos = pickup_object.global_transform.origin
		var hand_pos = hand.global_transform.origin
		# Calculate the direction and apply speed
		var dir = (hand_pos - obj_pos).normalized() * pull_speed
		# Move the object in that direction
		pickup_object.set_linear_velocity(dir)

func _unhandled_input(event):
	if Input.is_action_just_pressed("pickup"):
		# If user hits "f" or pickup button
		if pickup_object:
			if is_picked:
				# Drop object
				pickup_object.set_linear_velocity(Vector3.ZERO) # Stop moving the object when dropped
				pickup_object = null
				is_picked = false
			else:
				is_picked = true

	if Input.is_action_just_pressed("throw") and is_picked:
		is_picked = false
		var dir = -camera.global_transform.basis.z.normalized() * throw_speed
		pickup_object.apply_impulse(Vector3.ZERO, dir) # Correct use of apply_impulse
		pickup_object = null

func _on_body_entered(body):
	# First check if an object is picked up
	if not pickup_object or not is_picked:
		pickup_object = body
		print("Picked up: ", pickup_object)
