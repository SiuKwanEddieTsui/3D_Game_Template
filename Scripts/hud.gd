extends Control

func _ready():
	$CenterContainer/AppleCount.text = ""
	var object_script = get_node("/root/Level 1/Player/Camera/PickupArea")  # Correct path to your Area3D node
	object_script.connect("update_console", Callable(self, "_on_update_console"))
	var portal_script = get_node("/root/Level 1/Castle/StaticBody3D/Portal")
	portal_script.connect("update_console", Callable(self, "_on_update_console"))

func _on_collectibles_item_collected():
	$CenterContainer/AppleCount.text = str(global.apple_count)

func _on_hoops_shot_entered():
	$CenterContainer2/HoopCount.text = str(global.hoops)

func _on_update_console(message: String):
	$CenterContainer2/console.text = message
