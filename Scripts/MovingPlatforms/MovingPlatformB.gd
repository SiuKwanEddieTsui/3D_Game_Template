extends CharacterBody3D

@export var rotation_speed : float = 1.0

func _physics_process(delta):
	# Rotate the platform around its Y-axis
	rotate_y(rotation_speed * delta)
