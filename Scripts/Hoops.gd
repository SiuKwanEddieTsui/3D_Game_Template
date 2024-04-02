extends Node3D

var player_score = 0
var required_score = 10

func _on_area_3d_body_entered(body):
	if body is RigidBody3D:
		player_score += 1
		
		if player_score >= required_score:
			unlock_platforms()

	
func unlock_platforms():
	# Call the function in the platform manager script to unlock the platforms
	get_node("/root/PlatformManager").unlock_platforms()

