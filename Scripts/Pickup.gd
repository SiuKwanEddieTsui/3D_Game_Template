extends Area3D

@onready var hand = $"../hand"
@onready var camera = $".."

var pull_speed = 2

var pickup_object = null
var is_picked = false

func _physics_process(_delta):
	if pickup_object and is_picked:
		var obj_pos = pickup_object.global_transform.origin
		var hand_position = hand.global_transform.origin
		var dir = (hand_pos - obj_pos).normalized()
		dir = dir 
		pickup_object.set_axis_velocity(dir)

func _unhandled_input(event):
	if Input.is_action_just_pressed("pickup"):
		#if user hits "f" or pickup button
		if pickup_object:
			# if object already picked up
			if is_picked:
				# drop object
				pickup_object = null
				is_picked = false
			else:
				is_picked = true
				
	if Input.is_action_just_pressed("throw"):
		is_picked = false
		var dir = -camera.global_transform.basis.z.normalized()
		pickup_object.apply_impulse(dir)
		pickup_object = null
		

func _on_body_entered(body):
	# first check if an object is picked up
	if pickup_object and is_picked:
		# if so, end function here
		return
		pickup_object = body
		print(pickup_object)
