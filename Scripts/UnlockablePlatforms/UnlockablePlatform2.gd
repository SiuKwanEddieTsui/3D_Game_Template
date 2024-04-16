extends StaticBody3D

@export var unlock_count: int = 3

func _ready():
	lock()
	
	visible = false
	$CollisionShape3D.disabled = true

func unlock():
	visible = true
	print("Before enabling collision:", $CollisionShape3D.disabled)
	$CollisionShape3D.set_deferred("disabled", false)
	print("After enabling collision:", $CollisionShape3D.disabled)

func lock():
	visible = false
	$CollisionShape3D.disabled = true
	
