extends Control

func _ready():
	$CenterContainer2/Console.text = ""

func _on_collectibles_item_collected():
	$CenterContainer/AppleCount.text = str(global.apple_count)


func _on_pickup_area_update_console(message):
	$CenterContainer2/Console.text = message
