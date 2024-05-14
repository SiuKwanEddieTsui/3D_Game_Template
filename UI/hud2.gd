# hud.gd

extends Control

@onready var double_jump_unlock_message = $DoubleJumpUnlockMessage
@onready var air_dash_unlock_message = $AirDashUnlockMessage

func _ready():
	$CenterContainer/AppleCount.text = str(Global.apple_count)
	
	var object_script = $"../../Player/Camera/PickupArea"
	object_script.connect("update_console", Callable(self, "_on_update_console"))

	
	# Connect signals for ability unlocks
	var player = $"../../Player"
	if player.has_signal("double_jump_ability_unlocked"):
		player.connect("double_jump_ability_unlocked", Callable(self, "_on_double_jump_unlocked"))
	if player.has_signal("air_dash_ability_unlocked"):
		player.connect("air_dash_ability_unlocked", Callable(self, "_on_air_dash_unlocked"))

func _on_collectibles_item_collected():
	$CenterContainer/AppleCount.text = str(Global.apple_count)

func _on_hoops_shot_entered():
	$CenterContainer2/HoopCount.text = str(Global.hoops)

func _on_update_console(message: String):
	$CenterContainer2/console.text = message

# Show double jump icon when unlocked
func _on_double_jump_unlocked():
	$DoubleJumpIcon.visible = true
	double_jump_unlock_message.visible = true
	await get_tree().create_timer(3.0).timeout
	double_jump_unlock_message.visible = false

# Show air dash icon when unlocked
func _on_air_dash_unlocked():
	$AirDashIcon.visible = true
	air_dash_unlock_message.visible = true
	await get_tree().create_timer(3.0).timeout
	air_dash_unlock_message.visible = false


func _on_collectibles_6_body_entered(body):
	pass # Replace with function body.
