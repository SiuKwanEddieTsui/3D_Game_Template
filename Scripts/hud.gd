extends Control

func _ready():
	$CenterContainer/AppleCount.text = ""

func _on_collectibles_item_collected():
	$CenterContainer/AppleCount.text = str(global.apple_count)

func _on_hoops_shot_entered():
	$CenterContainer2/HoopCount.text = str(global.hoops)
