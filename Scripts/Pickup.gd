extends Area3D

@onready var hand = $"../hand"
@onready var camera = $".."

var pull_speed = 2
var throw_speed = 8

var pickup_object = null
var is_picked = false

func _physics_process(_delta):
	#check that we have an item picked up
	if pickup_object and is_picked:
		# get the distance between object and hand
		var obj_pos = pickup_object.global_transform.origin
		var hand_pos = hand.global_transform.origin
		# get the distance beteween object and hand
		var dir = (hand_pos - obj_pos).normalized() * pull_speed
		#move the object in that direction
		pickup_object.set_linear_velocity(dir)

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
