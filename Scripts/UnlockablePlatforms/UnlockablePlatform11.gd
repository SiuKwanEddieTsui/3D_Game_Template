extends StaticBody3D

func _ready():
	visible = false
	$CollisionShape3D.disabled = true

func unlock():
	visible = true
	print("Before enabling collision:", $CollisionShape3D.disabled)
	$CollisionShape3D.set_deferred("disabled", false)
	print("After enabling collision:", $CollisionShape3D.disabled)
