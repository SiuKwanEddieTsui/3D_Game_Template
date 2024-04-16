extends Area3D

var count = 0
@onready var count_label = get_node("/root/Level 1/UI/HUD/CenterContainer3/Score")
@onready var platforms: Array[NodePath] = ["/root/Level 1/Platforms/SecretPlatform/SecretPlatform", "/root/Level 1/Platforms/SecretPlatform2/SecretPlatform", "/root/Level 1/Platforms/SecretPlatform3/SecretPlatform", "/root/Level 1/Platforms/SecretPlatform4/SecretPlatform", "/root/Level 1/Platforms/SecretPlatform5/SecretPlatform"]

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body is RigidBody3D:
		count += 1
		update_count_label()

func update_count_label():
	if count_label != null:
		count_label.text = str(count)
		print("Count:", count)
	else:
		print("Count label not found!")
		
	for platform_path in platforms:
		var platform = get_node(platform_path)
		if platform != null:
			if count == platform.unlock_count:
				platform.unlock()
				print("Platform unlocked at count:", platform.unlock_count)
			else:
				print("Platform not found at path:", platform_path)
