extends CharacterBody3D

@export var distance : float = 5.0

var direction : int = 1
var start_position : Vector3

func _ready():
	start_position = position

func _physics_process(delta):
	var target_position = start_position + Vector3(0, direction * distance, 0)
	
	if position.distance_to(target_position) < 0.1:
		direction *= -1
	
	velocity = Vector3(0, direction * distance, 0)
	move_and_slide()
