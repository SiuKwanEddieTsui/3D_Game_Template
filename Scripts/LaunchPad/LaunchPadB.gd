# For a 3D platform
extends StaticBody3D

var launch_velocity = Vector3(50, 10, 50)  # Adjust for 3D; x, y (upward), and z directions

# Assuming this script is attached to the LaunchArea or Platform
func _on_launch_area_body_entered(body):
	if body.is_in_group("Player"):  # Make sure your player node is in the 'Player' group
		body.launch(Vector3(0, 200, 0))  # Adjust Vector3 for direction and strength of the launch
