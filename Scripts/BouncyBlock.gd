extends StaticBody3D

@export var spring_force := 1000.0

func _on_area_3d_body_entered(body):
	if body is CharacterBody3D:
		body.velocity.y += spring_force
